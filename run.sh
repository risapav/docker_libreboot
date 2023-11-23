
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

docker inspect --format {{.State.Pid}} magical_satoshi