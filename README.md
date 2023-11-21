# docker_libreboot
Generate alternative bios, LIBREBOOT
- https://libreboot.org/docs/install/ivy_has_common.uk.html
- https://libreboot.org/docs/maintain/


## Brief Introductions

In order for everything to work properly, it is necessary to familiarize yourself with the information 
from the page 
- https://libreboot.org/docs/maintain/

and have the necessary Git and Docker utilities ready. The system I use is Ubuntu.

[How to prepare utilities](utilities.md)

```sh
# install QEMU emulator
sudo apt install qemu-system-x86

qemu-system-x86_64 -bios bin/qemu_x86_12mb/grub_qemu_x86_12mb_libgfxinit_corebootfb_usqwerty_noblobs.rom

```

## Clone repository to local PC

Make sure git is installed.

```sh
git clone git@github.com:risapav/docker_libreboot.git && cd docker_libreboot
```

## Build libreboot docker environment

Prepare Docker environment, Docker should be installed and running. The philosophy of creating the final bios file is searchable on the site: 

- https://libreboot.org/docs/build/

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
  -v $PWD/bin:/home/sdk/lbmk/bin \
  libreboot-sdk
```

Libreboot’s build system named lbmk is accessible within docker container. How to work with lbmk is described
in the following link:

- https://libreboot.org/docs/maintain/

[Solved cases when deploying LibreBoot](deploying.md)
