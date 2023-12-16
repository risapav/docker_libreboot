#!/bin/sh
# set -ex
#
# add current user and user's primary group
#
groupadd -g $GGID $GGROUP
useradd  -u $GUID -s $GSHELL -c $GUSERNAME -g $GGID -M -d $GHOME $GUSERNAME
usermod  -a -G sudo $GUSERNAME
echo $GUSERNAME:docker | chpasswd
if [ "$GRUNXTERM" = "1" ]
then
    # become the current user and start a shell
    su -l -c lxterminal $GUSERNAME
    # another root shel
	source $1
    lxterminal
else
    # become the current user and start a shell
    su -l $GUSERNAME -c "source $1"
	su -l $GUSERNAME
    # another root shell
#    /bin/bash
fi