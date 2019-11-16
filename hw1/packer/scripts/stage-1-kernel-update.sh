#!/bin/bash


yum install -y ncurses-devel make gcc bc bison flex elfutils-libelf-devel openssl-devel grub2 wget perl bzip2 &&
cd /usr/src/ &&
wget https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.3.9.tar.xz &&
tar -xf linux-5.3.9.tar.xz &&
rm -f linux-5.3.9.tar.xz &&
cd linux-5.3.9 &&
cp -v /boot/config-$(uname -r) .config &&
make olddefconfig &&
make &&
make modules_install &&
make install &&

# Remove older kernels (Only for demo! Not Production!)
rm -f /boot/*3.10* &&
# Update GRUB
grub2-mkconfig -o /boot/grub2/grub.cfg &&
grub2-set-default 0 &&
echo "Grub update done."
# Reboot VM
shutdown -r now
