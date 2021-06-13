#!/bin/bash

PASSWORD=raspberry

sudo -S -v <<< $PASSWORD 2> /dev/null

function WGETWRITE() {
    URL="https://raw.githubusercontent.com/noahkamara/PiGadget/master/install_files$1"
    echo $URL
    sudo wget "$URL" -O "$1"
}


# Update
sudo apt-get update

# Install dnsmasq and wget
sudo apt-get -y install dnsmasq

# Clean Up
sudo apt-get clean

# WRITE /etc/dnsmasq.d/usb0
WGETWRITE "/etc/dnsmasq.d/usb0"

# WRITE /etc/network/interfaces.d/usb0
WGETWRITE "/etc/network/interfaces.d/usb0"

# WRITE /usr/local/sbin/pigadget.sh
mkdir /usr/local/sbin/
WGETWRITE "/usr/local/sbin/pigadget.sh"

# WRITE /lib/systemd/system/pigadget.service
WGETWRITE "/lib/systemd/system/pigadget.service"


# CHMOD pigadget.sh (make executable)
sudo chmod +x /usr/local/sbin/pigadget.sh

# SERVICE pigadget.service (enable service)
sudo systemctl enable pigadget.service

# ADD dtoverlay=dwc2 to /boot/config.txt
echo dtoverlay=dwc2 | sudo tee -a /boot/config.txt

# ADD modules-load=dwc2/ to /boot/cmdline.txt
sudo sed -i 's/$/ modules-load=dwc2/' /boot/cmdline.txt

# ENABLE SSH
sudo touch /boot/ssh

# ADD libcomposite to /etc/modules
echo libcomposite | sudo tee -a /etc/modules

# denyinterfaces usb0 to /etc/dhcpcd.conf
echo denyinterfaces usb0 | sudo tee -a /etc/dhcpcd.conf

# # Enable getty Service
# sudo systemctl enable getty@ttyGS0.service\n"

echo "WILL REBOOT NOW!"
sudo reboot
