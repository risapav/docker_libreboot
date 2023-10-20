# docker_libreboot
Generate alternative bios, LIBREBOOT

## Clone

Make sure git is installed.
```sh
git clone git@github.com:risapav/docker_libreboot.git && cd docker_libreboot
```

## Build

Prepare Docker environment, Docker should be installed and running.

```sh
# building pure sshd resvice with root access sourced from github
docker build https://github.com/risapav/docker_libreboot.git -t libreboot-sdk 

# building pure sshd resvice with root access from local repository
docker build -t libreboot-sdk .

# or

docker build risapav/docker_libreboot -t libreboot-sdk 
```

## How to run container

You should run container:
    
```sh    
docker run \
  --rm \
  -it \
  --user "$(id -u):$(id -g)" \
  --entrypoint /bin/bash \
  -v $PWD/project:/project \
  -v $PWD/tmp:/home/sdk/lbmk/tmp \
  -v $PWD/src:/home/sdk/lbmk/src \
  libreboot-sdk
```

## Original bios extraction

For example, you can read both bios part from x230 motherboard. You will obtain bootom.rom and top.rom files. In general, the 4mb image is the top, and the 8mb image is the bottom. To create a readable rom file, simply concatenate the two files.

```sh  
cat bottom.rom top.rom > full_backup.bin
```

Within running container, copy full_backup.bin into /home/lboot/lbmk

```sh 
cp /project/x220/full_backup.bin /home/lboot/lbmk/
```

Once you have a backup of your vendor rom, you can use lbmk to automatically extract the necessary blobs. The blob extraction script takes a board name as the first argument and a path to a rom as the second argument. For example, here is how you would extract the blobs from an x230 rom backup.

```sh  
./blobutil extract x230_12mb full_backup.bin
```

Note that the above command must be run from the root of the lbmk directory. 

## Injecting Blobs into an Existing Rom

Lbmk includes a script that will automatically inject the necessary blobs into a rom file. The script can determine the board automatically if you have not changed the name, but you can also manually set the board name with the -b flag.

In order to inject the necessary blobs into a rom image, run the script from the root of lbmk and point to the rom image.

If you only wish to flash a release rom then the process of injecting the necessary blobs is quite simple. Run the injection script pointing to the release archive you downloaded:

```sh 
./blobutil inject /path/to/libreboot-20230319-18-g9f76c92_t440pmrc_12mb.tar.xz
```

The script can automatically detect the board as long as you do not change the file name. You can then find flash-ready ROMs in /bin/release/

Alternatively, you may patch only a single rom file. For example:

```sh 
./blobutil inject -r x230_libreboot.rom -b x230_12mb
```

Optionally, you can use this script to modify the mac address of the rom with the -m flag. For example:

```sh 
./blobutil inject -r x230_libreboot.rom -b x230_12mb -m 00:f6:f0:40:71:fd
```

## Splitting The rom

You can use dd to easily split your rom into the two separate portions for external flashing. For example, here is how you would split a 12mb rom for installation:

```sh 
dd if=libreboot.rom of=top.rom bs=1M skip=8
dd if=libreboot.rom of=bottom.rom bs=1M count=8
```

You would then flash the 4MiB chip with top.rom and the 8MiB chip with bottom.rom. For a larger rom image, the same logic would apply.

In dd skip means that you want the program to ignore the first n blocks, whereas count means you want it to stop writing after n blocks.

Once you have your rom image split you can proceed to flashing.

