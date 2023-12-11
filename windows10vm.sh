#!/bin/bash

vmname="windows10vm"

if ps -A | grep -q $vmname; then
	echo "$vmname is already running." &
	exit 1

else

# use pulseaudio
export QEMU_AUDIO_DRV=pa
export QEMU_PA_SAMPLES=8192
export QEMU_AUDIO_TIMER_PERIOD=99
export QEMU_PA_SERVER=/run/user/1000/pulse/native

cp /usr/share/OVMF/OVMF_VARS.fd /tmp/my_vars.fd

qemu-system-x86_64 \
  -name $vmname,process=$vmname \
  -machine type=q35,accel=kvm \
  -cpu host,kvm=off \
  -smp 4,sockets=1,cores=2,threads=2 \
  -m 4G \
  -mem-path /run/hugepages/kvm \
  -mem-prealloc \
  -balloon none \
  -rtc clock=host,base=localtime \
  -vga none \
  -nographic \
  -serial none \
  -parallel none \
  -soundhw hda \
  -usb -usbdevice host:045e:076c -usbdevice host:045e:0750 \
  -device vfio-pci,host=02:00.0,multifunction=on \
  -device vfio-pci,host=02:00.1 \
  -drive if=pflash,format=raw,readonly,file=/usr/share/OVMF/OVMF_CODE.fd \
  -drive if=pflash,format=raw,file=/tmp/my_vars.fd \
  -boot order=dc \
  -drive id=disk0,if=virtio,cache=none,format=raw,file=/media/user/win.img \
  -drive file=/home/user/ISOs/win10.iso,index=3,media=cdrom \
  -drive file=/home/user/Downloads/virtio-win-0.1.140.iso,index=4,media=cdrom \
  -netdev type=tap,id=net0,ifname=tap0,vhost=on \
  -device virtio-net-pci,netdev=net0,mac=00:16:3e:00:01:01

	exit 0
fi