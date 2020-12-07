#!/bin/bash

PASSWORD=raspberry
URL="https://raw.githubusercontent.com/noahkamara/PiGadget/master/install_files"
sudo -S -v <<< $PASSWORD 2> /dev/null

function WRITE() {
    echo $URL
    wget $URL$1 $1
}


# Update
sudo apt-get update

# Install dnsmasq and wget
sudo apt-get -y install dnsmasq

# Clean Up
sudo apt-get clean

# WRITE /etc/dnsmasq.d/usb0
WRITE "/etc/dnsmasq.d/usb0"

# WRITE /etc/network/interfaces.d/usb0
WRITE "/etc/network/interfaces.d/usb0"

# WRITE /usr/local/sbin/pigadget.sh
mkdir /usr/local/sbin/
WRITE "/usr/local/sbin/pigadget.sh"

# WRITE /lib/systemd/system/pigadget.service
WRITE "/lib/systemd/system/pigadget.service"


# CHMOD pigadget.sh (make executable)
chmod +x /usr/local/sbin/pigadget.sh

# SERVICE pigadget.service (enable service)
systemctl enable pigadget.service

# ADD dtoverlay=dwc2 to /boot/config.txt
echo dtoverlay=dwc2 >> /boot/config.txt

# ADD modules-load=dwc2/ to /boot/cmdline.txt
sed -i 's/$/ modules-load=dwc2/' /boot/cmdline.txt

# ENABLE SSH
touch /boot/ssh

# ADD libcomposite to /etc/modules
echo libcomposite >> /etc/modules

# denyinterfaces usb0 to /etc/dhcpcd.conf
echo denyinterfaces usb0 >> /etc/dhcpcd.conf

# # Enable getty Service
# sudo systemctl enable getty@ttyGS0.service\n"

# echo "WILL REBOOT NOW!"
# sudo reboot
