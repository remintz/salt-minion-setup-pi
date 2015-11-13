#
# Raspberry Pi Setup to work as a salt minion for a specific salt server
#

Based on Fabien's https://github.com/fpapleux/raspi

1. The first step I normally go through is to grab the latest Raspbian distribution and [load it onto an SD card](https://github.com/fpapleux/raspi/wiki/Step-1:-Loading-Raspbian-onto-an-SD-Card) to get started.

2. Next, it is time to run your Raspberry Pi for the first time.

In order to run the next steps, please make sure your raspberry pi is connected to the internet.  On first boot, you would ideally plug in an ethernet cable. 

	1. Start your Raspberry Pi. It will boot automatically into the configuration tool, raspi-config. Just exit without making any change.

	2. Install this system by cloning this repository. It is done by typing the following commands:
		```
		cd ~
		git clone https://github.com/remintz/salt-minion-setup-pi
		cd salt-minion-setup-pi
		```

	3. Execute ``` sudo ./init.sh ``` to go through the initialization process.

	4. Reboot the system as suggested
