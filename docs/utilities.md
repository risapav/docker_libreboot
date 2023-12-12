# Required utilities

## Git

## Docker

You can find information about installing Docker on the site
- https://docs.docker.com/engine/install/ubuntu/

***1. Run the following command to uninstall all conflicting packages***

```sh
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove $pkg; done
```

***2. Install using the apt repository***

```sh
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

***3. Install the Docker packages***

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

***4. Verify that the Docker Engine installation is successful by running the hello-world image***

```sh
sudo docker run hello-world
```

***5. Manage Docker as a non-root user***

You can find information about linux post-installing on the site
- https://docs.docker.com/engine/install/linux-postinstall/

```sh
# Create the docker group
sudo groupadd docker

# Add your user to the docker group.
sudo usermod -aG docker $USER
newgrp docker

# Verify that you can run docker commands without sudo.
docker run hello-world

# Correct permissions
mkdir ~/.docker
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R
```

***6. Configure Docker to start on boot with systemd***

```sh
# Configure Docker to start on boot with systemd
sudo systemctl enable docker.service
sudo systemctl enable containerd.service
```

### To stop this behavior, use disable instead.

```sh
sudo systemctl disable docker.service
sudo systemctl disable containerd.service
```

### Uninstall Docker Engine

Uninstall the Docker Engine, CLI, containerd, and Docker Compose packages:

```sh
sudo apt-get purge docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-ce-rootless-extras
```

Images, containers, volumes, or custom configuration files on your host aren't automatically removed. To delete all images, containers, and volumes:

```sh
sudo rm -rf /var/lib/docker
sudo rm -rf /var/lib/containerd
``` 
You have to delete any edited configuration files manually.




## QEMU emulator

QEMU is a generic and open source machine emulator and virtualizer.
- https://wiki.qemu.org/Main_Page
- https://www.qemu.org/
- https://www.tecmint.com/install-qemu-kvm-ubuntu-create-virtual-machines/

This is a very useful tool when debugging Coreboot and LibreBoot. The finished product can be launched and tested virtually.

***1. Check Virtualization Enabled in Ubuntu***

To start off check if your CPU supports virtualization technology. Your system needs to have an Intel VT-x (vmx) processor or AMD-V (svm) processor.
To verify this, run the following egrep command.

```sh
$ egrep -c '(vmx|svm)' /proc/cpuinfo
```

If Virtualization is supported, the output should be greater than 0, for example, 2,4,6, etc.
Alternatively, you can run the following grep command to display the type of processor your system supports. In our case, we are running Intel VT-x denoted by the vmx parameter.

```sh
$ grep -E --color '(vmx|svm)' /proc/cpuinfo
```

***2. Install QEMU/KVM on Ubuntu 20.04/22.04***

Next up, update the package lists and repositories as follows.
```sh
sudo apt update
```
Thereafter, install QEMU/KVM alongside other virtualization packages as follows:
```sh
sudo apt install qemu-kvm virt-manager virtinst libvirt-clients bridge-utils libvirt-daemon-system -y
```

Let us examine what role each of these packages plays.

- qemu-kvm – This is an open-source emulator that emulates the hardware resources of a computer.
- virt-manager – A Qt-based GUI interface for creating and managing virtual machines using the libvirt daemon.
- virtinst – A collection of command-line utilities for creating and making changes to virtual machines.
- libvirt-clients – APIs and client-side libraries for managing virtual machines from the command line.
- bridge-utils – A set of command-line tools for managing bridge devices.
- libvirt-daemon-system – Provides configuration files needed to run the virtualization service.

At this point, we have installed QEMU and all the essential virtualization packages. T

***3. Start and enable the libvirtd virtualization daemon.***

```sh
sudo systemctl enable --now libvirtd
sudo systemctl start libvirtd
```

***4. Verify if the virtualization service is running.***

```sh
sudo systemctl status libvirtd
```

***5. Add the currently logged-in user to the kvm and libvirt groups.***

```sh
sudo usermod -aG kvm $USER
sudo usermod -aG libvirt $USER
```

```sh
# install QEMU emulator
sudo apt install qemu-system-x86

qemu-system-x86_64 -bios bin/qemu_x86_12mb/grub_qemu_x86_12mb_libgfxinit_corebootfb_usqwerty_noblobs.rom

```
