# **Домашнее задание №2: работа с mdadm**
**Цель:** Получить навыки работы с Git, Vagrant, Packer и публикацией готовых образов в Vagrant Cloud.

## **Задание:**
- добавить в Vagrantfile еце дисков
- собрать R0/R5/R10 на выбор
- прописать собранный рейд в конф, чтобы рейд собирался при загрузке
- сломать/починить raid
- создать GPT раздел и 5 партиций и смонтировать их на диск.

В качестве проверки принимается - измененный Vagrantfile, скрипт для
создания рейда, конф для автосборки рейда при загрузке.

* Доп. задание - Vagrantfile, который сразу собирает систему с подключенным
рейдом

## **Выполнено**

sudo lshw -short | grep disk
sudo mdadm --zero-superblock --force /dev/sd{b,c,d,e,f}
sudo mdadm --create --verbose /dev/md0 -l 6 -n 5 /dev/sd{b,c,d,e,f}
cat /proc/mdstat
sudo mdadm -D /dev/md0
sudo mkdir /etc/mdadm
sudo  mdadm --detail --scan --verbose | awk '/ARRAY/ {print}' | sudo tee /etc/mdadm/mdadm.conf



[vagrant@otuslinuxhw2 ~]$ lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   40G  0 disk
`-sda1   8:1    0   40G  0 part /
sdb      8:16   0  250M  0 disk
sdc      8:32   0  250M  0 disk
sdd      8:48   0  250M  0 disk
sde      8:64   0  250M  0 disk
sdf      8:80   0  250M  0 disk



 

