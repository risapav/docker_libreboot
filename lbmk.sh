#!/usr/bin/env sh

docker run \
  --rm \
  -it \
  --user "$(id -u):$(id -g)" \
  --entrypoint /bin/bash \
  -v $PWD/project:/project \
  -v $PWD/lbmk/tmp:/home/sdk/lbmk/tmp \
  -v $PWD/lbmk/src:/home/sdk/lbmk/src \
  -v $PWD/lbmk/bin:/home/sdk/lbmk/bin \
  -v $PWD/lbmk/elf:/home/sdk/lbmk/elf \
  -v $PWD/lbmk/resource:/home/sdk/lbmk/resource \
  -v $PWD/lbmk/config:/home/sdk/lbmk/config \
  -v $PWD/lbmk/include:/home/sdk/lbmk/include \
  -v $PWD/lbmk/script:/home/sdk/lbmk/script \
  -v $PWD/lbmk/util:/home/sdk/lbmk/util \
  libreboot-sdk