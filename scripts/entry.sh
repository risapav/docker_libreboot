#!/bin/sh
# set -ex
echo $PWD

mkdir -p ~/lbmk
cd ~/lbmk
# Git 
if ! git ls-files >& /dev/null; then
  git clone https://codeberg.org/libreboot/lbmk.git ~/lbmk --progress 2>&1
fi;