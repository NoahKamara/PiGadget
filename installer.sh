#!/bin/bash

PASSWORD=raspberry

sudo -S -v <<< $PASSWORD 2> /dev/null

function WRITE() {
    sudo wget $1 $2
}


# Update
sudo apt-get update

# Install dnsmasq and wget
sudo apt-get -y install dnsmasq
sudo apt-get -y install wget

# Clean Up
sudo apt-get clean

# WRITE etc/dnsmasq.d/usb0
WRITE "URL" "/etc/dnsmasq.d/usb0"


EOF
expect "# "
send "\n"
send "$file\n"
send "\n"

set file [slurp "etc/network/interfaces.d/usb0"]
expect "# "
send "cat <<EOF >> /etc/network/interfaces.d/usb0\n"
send "$file\n"
send "EOF\n"

set file [slurp "usr/local/sbin/usb-gadget.sh"]
expect "# "
send "cat <<EOF >> /usr/local/sbin/usb-gadget.sh\n"
send "$file\n"
send "EOF\n"
expect "# "
send "chmod +x /usr/local/sbin/usb-gadget.sh\n"

set file [slurp "lib/systemd/system/usbgadget.service"]
expect "# "
send "cat <<EOF >> /lib/systemd/system/usbgadget.service\n"
send "$file\n"
send "EOF\n"
expect "# "
send "systemctl enable usbgadget.service\n"

expect "# "
send "echo dtoverlay=dwc2 >> /boot/config.txt\n"

expect "# "
send "sed -i 's/$/ modules-load=dwc2/' /boot/cmdline.txt \n"

expect "# "
send "touch /boot/ssh\n"

expect "# "
send "echo libcomposite >> /etc/modules\n"

expect "# "
send "echo denyinterfaces usb0 >> /etc/dhcpcd.conf\n"

expect "# "
send "sudo systemctl enable getty@ttyGS0.service\n"

expect "# "
send "poweroff\n"

interact
