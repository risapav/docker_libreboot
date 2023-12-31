Deploying.md
================

---
# Contents

- [Framework Scripts](#framework-scripts)
- [Original bios extraction](#original-bios-extraction)
- [Splitting The rom](#splitting-the-rom)
- [Thinkpad X220 FullHD mod with LVDS](#thinkpad-x220-fullhd-mod-with-lvds)
- [Build libreboot ROM](#build-libreboot-rom)
- [Injecting Blobs into an Existing Rom](#injecting-blobs-into-an-existing-rom)
- [Check that the files were inserted](#check-that-the-files-were-inserted)
- [Prepare QEMU emulator](#prepare-qemu-emulator)
---
## Framework Scripts

***1. vendor inject***

```sh
USAGE: ./vendor inject -r [rom path] -b [boardname] -m [macaddress]
Example: ./vendor inject -r x230_12mb.rom -b x230_12mb

Adding a macadress to the gbe is optional.
If the [-m] parameter is left blank, the gbe will not be touched.

Type './vendor inject listboards' to get a list of valid boards
```

***2. update trees***

Special operation: for building coreboot utilities cbfstool and ifdtool to go under cbutils/, do this:

./update trees -b coreboot utils
Or define specific coreboot tree such as:

./update trees -b coreboot utils default
./update trees -b coreboot utils cros
FLAG values are (only one to be used at a time):

USAGE: ./update trees FLAG projectname

FLAG

- -b builds an image for the target, based on defconfig for multi-tree projects, or based only on a Makefile for single-tree projects; on some single-tree projects, this script also handles cmake.
- -u runs make oldconfig on the target’s corresponding source tree, using its defconfig (useful for automatically updating configs, when updating trees like when adding patches or switching git revisions)
- -m runs make menuconfig on the target’s corresponding source tree, using its defconfig (useful for modifying configs, e.g. changing CBFS size on a coreboot image)
- -c tries make distclean, deferring to make clean under fault conditions and from that, non-zero exit under fault conditions. This is done on the target’s corresponding source tree.
- -x tries ’make crossgcc-clean`. This only works on coreboot trees, but no error status will be returned on exit if you try it on other project trees; no action will be performed.
- -f downloads the Git repository for the given project, and resets to a revision as defined under config/git/, or (for multi-tree projects), the file config/PROJECT/TREE/target.cfg to create src/project/treename.

Example commands:
```sh
./update trees -b coreboot
./update trees -b coreboot x200_8mb
./update trees -b coreboot x230_12mb x220_8mb t1650_12mb
./update trees -x coreboot default
./update trees -u seabios
./update trees -m u-boot gru_bob
./update trees -f coreboot
./update trees -b coreboot utils default
./update trees -b coreboot utils
```

***3. update release***

This script builds the release archives, which are then provided in a new Libreboot release. Most users do not need to look at this file at all, but it is provided under free license for curious souls.

USAGE: ./update release

NOTE: if the -d option is used, you can specify a directory other than release. For example:

```sh
./update release -d /media/stuff/libreboot_release_test
```

If -d is not passed, they will go under release/ in your lbmk repository. The script is engineered to re-initialise git if ran from a release archive. Libreboot releases after 20230625 include .gitignore in the src archive.

***4. build grub***

```sh
elfdir="elf/grub"
grubcfgsdir="config/grub"
layoutdir="/boot/grub/layouts"

. "${grubcfgsdir}/modules.list"

```

***5. build roms***

```sh
seavgabiosrom="elf/seabios/default/libgfxinit/vgabios.bin"
grub_background="background1280x800.png"
grubelf="elf/grub/grub.elf"
cfgsdir="config/coreboot"
kmapdir="config/grub/keymap"

# Disable all payloads by default.
# target.cfg files have to specifically enable [a] payload(s)
pv="payload_grub payload_grub_withseabios payload_seabios payload_memtest"
pv="${pv} payload_seabios_withgrub payload_seabios_grubonly payload_uboot memtest_bin"
v="romdir cbrom initmode displaymode cbcfg targetdir tree arch"
v="${v} grub_timeout ubdir vendorfiles board grub_scan_disk uboot_config"
eval "$(setvars "n" ${pv})"
eval "$(setvars "" ${v} boards _displaymode _payload _keyboard all targets)"

USAGE:	./build roms targetname
	To build *all* boards, do this: ./build roms all
	To list *all* boards, do this: ./build roms list
	
	Optional Flags:
	-d: displaymode
	-p: payload
	-k: keyboard layout
	
	Example commands:
		./build roms x60
		./build roms x200_8mb x60
		./build roms x60 -p grub -d corebootfb -k usqwerty
	
	possible values for 'target':
	$(items "config/coreboot")
	
	Refer to the ${projectname} documentation for more information.
```

***6. build serprog***

```sh
USAGE: ./build firmware serprog <rp2040|stm32> [board]"
```
 
## Original bios extraction

For example, you can read both bios part from x230 motherboard. You will obtain bootom.rom and top.rom files. In general, the 4mb image is the top, and the 8mb image is the bottom. To create a readable rom file, simply concatenate the two files.

```sh  
# for x220_8mb
cat x220_8mb > full_backup.bin

#for x230_12mb
cat bottom.rom top.rom > full_backup.bin
cat 8mb.rom 4mb.rom > full_backup.bin
```

Inside running container, copy full_backup.bin into /home/sdk/lbmk

```sh 
# for x220_8mb
cp /project/x220/full_backup.bin /home/sdk/lbmk/

#for x230_12mb
cp /project/x230/full_backup.bin /home/sdk/lbmk/
```

Once you have a backup of your vendor rom, you can use lbmk to automatically extract the necessary blobs. The blob extraction script takes a board name as the first argument and a path to a rom as the second argument. For example, here is how you would extract the blobs from an x230 rom backup.

```sh  
# for x220_8mb
./vendor extract x220_8mb full_backup.bin

#for x230_12mb
./vendor extract x230_12mb full_backup.bin
```

Note that the above command must be run from the root of the lbmk directory. 

---

## Splitting The rom

You can use dd to easily split your rom into the two separate portions for external flashing. For example, here is how you would split a 12mb rom for installation:

```sh 
dd if=libreboot.rom of=top.rom bs=1M skip=8
dd if=libreboot.rom of=bottom.rom bs=1M count=8

#for x230_12mb
dd if=grub_x230_12mb_libgfxinit_corebootfb_usqwerty.rom of=top.rom bs=1M skip=8
dd if=grub_x230_12mb_libgfxinit_corebootfb_usqwerty.rom of=bottom.rom bs=1M count=8
```

You would then flash the 4MiB chip with top.rom and the 8MiB chip with bottom.rom. For a larger rom image, the same logic would apply.

In dd skip means that you want the program to ignore the first n blocks, whereas count means you want it to stop writing after n blocks.

Once you have your rom image split you can proceed to flashing.

---

## Thinkpad X220 FullHD mod with LVDS 
- https://daduke.org/hardware/x220-fhd/

First locate gma-mainboard.ads file inside src/coreboot/default/src/mainboard/lenovo/x220

Then Edit file and delete line "LVDS"

```sh

gma-mainboard.ads 

-- SPDX-License-Identifier: GPL-2.0-or-later

with HW.GFX.GMA;
with HW.GFX.GMA.Display_Probing;

use HW.GFX.GMA;
use HW.GFX.GMA.Display_Probing;

private package GMA.Mainboard is

  ports : constant Port_List :=
    (DP1,
     DP2,
     DP3,
     HDMI1,
     HDMI2,
     HDMI3,
     Analog,
     LVDS,  <----------- delete this line 
     others => Disabled);

end GMA.Mainboard;
```

---

## Build libreboot ROM

Run the script inside lbmk.

```sh 
# collect all possibilities to choose one
./build roms list

# for qemu_x86_12mb
./build roms qemu_x86_12mb -p grub -d corebootfb -k usqwerty

# for x200_8mb
./build roms x200_8mb -p grub -d corebootfb -k usqwerty

# for x220_8mb
./build roms x220_8mb -p grub -d corebootfb -k usqwerty

#for x230_12mb
./build roms x230_12mb -p grub -d corebootfb -k usqwerty

#    decompose to parts
dd if=coreboot.rom of=coreboot-8mb.rom bs=1M count=8 
dd if=coreboot.rom of=coreboot-4mb.rom bs=1M skip=8

# for t420_8mb
./build roms t420_8mb -p grub -d corebootfb -k usqwerty
```

---

## Injecting Blobs into an Existing Rom

Run the script inside lbmk.

Lbmk includes a script that will automatically inject the necessary blobs into a rom file. The script can determine the board automatically if you have not changed the name, but you can also manually set the board name with the -b flag.

In order to inject the necessary blobs into a rom image, run the script from the root of lbmk and point to the rom image.

If you only wish to flash a release rom then the process of injecting the necessary blobs is quite simple. Run the injection script pointing to the release archive you downloaded:

```sh 
./vendor inject /path/to/libreboot-20230319-18-g9f76c92_t440pmrc_12mb.tar.xz

# to update MAC address x200_8mb
./vendor inject -r bin/x200_8mb/grub_x200_8mb_libgfxinit_corebootfb_usqwerty_noblobs.rom -b x200_8mb -m 00:1f:16:38:40:18

# for x220_8mb to patch single ROM file
./vendor inject x220_libreboot.rom

./vendor inject -r x220_libreboot.rom -b x220_8mb

# to update MAC address
./vendor inject -r x220_libreboot.rom -b x220_8mb -m 00:f6:f0:40:71:fd

./vendor inject -r bin/x220_8mb/grub_x220_8mb_libgfxinit_corebootfb_usqwerty.rom -b x220_8mb
./vendor inject -r bin/x220_8mb/grub_x220_8mb_libgfxinit_corebootfb_usqwerty.rom -b x220_8mb -m 00:f6:f0:40:71:fd

# for x230_12mb to patch single ROM file
./vendor inject -r bin/x230_12mb/grub_x230_12mb_libgfxinit_corebootfb_usqwerty.rom -b x220_8mb -m 3c:97:0e:3c:7d:a3

# for t420_8mb to patch single ROM file
./vendor inject -r bin/t420_8mb/grub_t420_8mb_libgfxinit_corebootfb_usqwerty.rom -b t420_8mb
./vendor inject -r bin/t420_8mb/grub_t420_8mb_libgfxinit_corebootfb_usqwerty.rom -b t420_8mb -m 00:21:cc:c0:4e:37
```

The script can automatically detect the board as long as you do not change the file name. You can then find flash-ready ROMs in /bin/release/

Alternatively, you may patch only a single rom file. For example:

```sh 
#for x230_12mb
./vendor inject -r x230_libreboot.rom -b x230_12mb
```

Optionally, you can use this script to modify the mac address of the rom with the -m flag. For example:

```sh 
./vendor inject -r x230_libreboot.rom -b x230_12mb -m 00:f6:f0:40:71:fd
```

---

## Check that the files were inserted

Run the script inside lbmk.

You must ensure that the files were inserted.

Some examples of how to do that in lbmk:
```sh 
./update trees -b coreboot utils
```

Now you find cbutitls/default, which is a directory containing cbfstool and ifdtool. Do this on your ROM image (libreboot.rom in the example below):
```sh 
./cbutils/default/cbfstool libreboot.rom print
```

You should check that the files were inserted in cbfs, if needed; for example, EC firmware or MRC firmware.

Next:

```sh 
./cbutils/default/ifdtool -x libreboot.rom
```

This creates several .bin files, one of which says me in it (Intel ME). Run hexdump on it:

hexdump flashregion_2_intel_me.bin

Check the output. If it’s all 0xFF (all ones) or otherwise isn’t a bunch of code, then the Intel ME firmware wasn’t inserted.

You’ll note the small size of the Intel ME, e.g. 84KB on sandybridge platforms. This is because lbmk automatically neuters it, disabling it during early boot. This is done using me_cleaner, which lbmk imports.

---

## Prepare QEMU emulator
https://qemu-project.gitlab.io/qemu/system/devices/usb.html

Run the script inside lbmk.

```sh 
# buil for qemu_x86_12mb
./build roms qemu_x86_12mb -p grub -d corebootfb -k usqwerty
```

Run the script in host.

```sh 
qemu-system-x86_64 -bios bin/qemu_x86_12mb/grub_qemu_x86_12mb_libgfxinit_corebootfb_usqwerty_noblobs.rom
```


## Builds payloadds

If you wish to build payloads, you can also do that. For example:

./build payload grub

./build payload seabios

Second, download all of the required software components

If you didn’t simply run ./build boot roms (with or without extra arguments), you can still perform the rest of the build process manually. Read on! You can read about all available scripts in lbmk by reading the Libreboot maintenance manual; lbmk is designed to be modular which means that each script can be used on its own (if that’s not true, for any script, it’s a bug that should be fixed).

It’s as simple as that:

./download all

The above command downloads all modules defined in the Libreboot build system. However, you can download modules individually.

This command shows you the list of available modules:

./download list

Example of downloading an individual module:

./download coreboot

./download seabios

./download grub

./download flashrom

Third, build all of the modules:

Building a module means that it needs to have already been downloaded. Currently, the build system does not automatically do pre-requisite steps such as this, so you must verify this yourself.

Again, very simple:

./build module all

This builds every module defined in the Libreboot build system, but you can build modules individually.

The following command lists available modules:

./build module list

Example of building specific modules:

./build module grub

./build module seabios

./build module flashrom

Commands are available to clean a module, which basically runs make-clean. You can list these commands:

./build clean list

Clean all modules like so:

./build clean all

Example of cleaning specific modules:

./build clean grub

./build clean cbutils

Fourth, build all of the payloads:

Very straight forward:

./build payload all

You can list available payloads like so:

./build payload list

Example of building specific payloads:

./build payload grub

./build payload seabios

The build-payload command is is a prerequsite for building ROM images.



