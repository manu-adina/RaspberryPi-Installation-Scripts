#!/bin/bash

printf '#########################\n\n'

printf 'Installing RLT8812AU Driver for Pi 3B+ with Raspbian Buster\n\n'

if sudo apt-get -y --assume-yes install bc raspberrypi-kernel-headers dkms ; then
	printf '\nSuccesfully Installed RTL8812AU Driver Dependencies\n\n'
else
	printf '\nFailed to Install RTL8812AU Driver Dependencies\n\n'
	exit 1
fi

cd ~/Downloads
if git clone https://github.com/aircrack-ng/rtl8812au.git --depth=1 ; then
	printf '\nDownloaded Driver\n\n'
else
	printf '\nFailed to Download Driver\n\n'
	exit 1
fi

cd rtl8812au

sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/g' Makefile
sed -i 's/CONFIG_PLATFORM_ARM64_RPI = n/CONFIG_PLATFORM_ARM64_RPI = y/g' Makefile
sed -i 's/^dkms build/ARCH=arm dkms build/' dkms-install.sh
sed -i 's/^MAKE="/MAKE="ARCH=arm\ /' dkms.conf

if sudo ./dkms-install.sh ; then
	printf '\nDone installing RLT8812AU Driver\n\n'
else
	printf '\nFailed to Install RLT8812AU Driver\n\n'
	exit 1
fi
