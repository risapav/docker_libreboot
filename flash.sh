#!/bin/bash

# just keep in mind, flashrom -p internal is only allowable when kernel is in iomem=relaxed state.
# To sacrify this it is neccessary:
# sudo -H gedit /etc/default/grub file
# Then change: GRUB_CMDLINE_LINUX_DEFAULT="iomem=relaxed quiet splash"
# save and exit gedit
#run: sudo update-grub
#reboot
#after rebooting type:  cat /proc/cmdline
#if you see iomem=relaxed
#flashrom -p internal should work


sudo flashrom -p internal -c "MX25L6405" -r bios.rom
sudo flashrom -p internal -c "MX25L6405" -w grub_t420_8mb_libgfxinit_corebootfb_usqwerty.rom
