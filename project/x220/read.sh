#!/bin/bash


lsusb
sudo chmod o+w /dev/bus/usb/003/004
sudo chmod o+w /dev/bus/usb/004/003
flashrom -p ch341a_spi -r stock_bios.bin -c "MX25L6436E/MX25L6445E/MX25L6465E/MX25L6473E/MX25L6473F"
flashrom -p ch341a_spi -r stock_bios_1.bin -c "MX25L6436E/MX25L6445E/MX25L6465E/MX25L6473E/MX25L6473F"
diff stock_bios.bin stock_bios_1.bin
