#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

#Bus 003 Device 002:
sudo chmod o+w /dev/bus/usb/003/002

flashrom -p ch341a_spi -r rom.rom -c "MX25L6405D"
flashrom -p ch341a_spi -r rom1.rom -c "MX25L6405D"
diff rom1.rom rom.rom

flashrom -p ch341a_spi -w grub_x200_8mb_libgfxinit_corebootfb_usqwerty_noblobs.rom -c "MX25L6405D"
