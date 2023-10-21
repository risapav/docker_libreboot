#!/bin/bash
# SPDX-License-Identifier: GPL-3.0+

#for x230_12mb
dd if=grub_x230_12mb_libgfxinit_corebootfb_usqwerty.rom of=top.rom bs=1M skip=8
dd if=grub_x230_12mb_libgfxinit_corebootfb_usqwerty.rom of=bottom.rom bs=1M count=8