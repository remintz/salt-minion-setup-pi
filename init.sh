#!/bin/bash

disable_raspi_config_at_boot() {
  if [ -e /etc/profile.d/raspi-config.sh ]; then
    rm -f /etc/profile.d/raspi-config.sh
    sed -i /etc/inittab \
      -e "s/^#\(.*\)#\s*RPICFG_TO_ENABLE\s*/\1/" \
      -e "/#\s*RPICFG_TO_DISABLE/d"
    telinit q
  fi
}

clear; echo -e "\n\n\n\n\n\n\n\n\n\n"
echo -e "-------------------------------------------------------------------------------------"
echo -e "| Initializing new RaspberryPi                                                      |"
echo -e "-------------------------------------------------------------------------------------"
echo -e "\n- Make sure it is connected to the Internet... (probably use an ethernet cable at this point)"
echo -en "\n\n-- Press any key to continue --"; read -n 1 cont; echo


#####################################################################################
## RERESH SYSTEM WITH APT-GET LIBRARY UPDATE & UPGRADE
#####################################################################################

echo -e "\n"
echo -e " Updating APT-GET libraries and installed packages..."
echo -e "-------------------------------------------------------------------------------------"
sudo apt-get -y -qq update 							# Update library
sudo apt-get -y -qq upgrade 						# Upgrade all local libraries
sudo apt-get -y autoremove							# removes redundant packages after upgrade
echo -e "\n\nAPT-GET update complete\n\n"

#####################################################################################
## ADJUSTING SYSTEM SETTINGS
#####################################################################################

echo -e "\n"
echo -e " Setting US locale and keyboard..."
echo -e "-------------------------------------------------------------------------------------"
sudo cp -f files/locale.gen /etc/locale.gen 		# Set locale to US
sudo cp -f files/keyboard /etc/default/keyboard		# Set keyboard layout to US
echo -e "\n\nUS Locale & Keyboard setup complete\n\n"
# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

#####################################################################################
## Expand filesystem to the maximum on the card
#####################################################################################

echo -e "\n"
echo -e " Expanding file system..."
echo -e "-------------------------------------------------------------------------------------"

$HOME/raspi/expand_filesystem.sh
echo -e "\n\nFilesystem expansion complete"
# echo -n "-- Press any key to continue --"; read -n 1 cont; echo

#####################################################################################
## Install salt minion
#####################################################################################

echo -e "\n\nInstall salt minion pointing to master at salt.acn-iot.com"
echo -e "-------------------------------------------------------------------------------------"
echo "deb http://debian.saltstack.com/debian wheezy-saltstack main" > /etc/apt/sources.list.d/saltstack.list
wget -q -O- "http://debian.saltstack.com/debian-salt-team-joehealy.gpg.key" | apt-key add -
apt-get update
apt-get -y -qq install salt-minion
sed -i 's/#master: salt$/master: salt.acn-iot.com/' /etc/salt/minion
service salt-minion restart

#####################################################################################
## Change /etc/rc.local appending script to set hostname automatically
#####################################################################################

echo -e "\n\nChange rc.local to set hostname automatically"
echo -e "-------------------------------------------------------------------------------------"
sed -i 's/exit 0$//' /etc/rc.local
cat files/rc.local.append >> /etc/rc.local

#####################################################################################
## Add salt master key
#####################################################################################

echo -e "\n\nCopy salt master key"
echo -e "-------------------------------------------------------------------------------------"
mkdir -p /etc/salt/pki/minion
cp -f files/salt-master-key /etc/salt/pki/minion/master_sign.pub

#####################################################################################
## Reboot the machine
#####################################################################################

echo -e "\n"
echo "---------------------------------------------------------------------------------"
echo "Based on the work that was just completed we recommend that you restart your"
echo "machine and log back in using your new user account to continue this process."
echo "------------------------ PRESS ANY KEY TO CONTINUE ------------------------------"
read -n 1 q; echo
disable_raspi_config_at_boot
sudo shutdown -r now

