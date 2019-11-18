# **Домашнее задание №3: Работа с LVM**

## **Задание:**
на имеющемся образе
/dev/mapper/VolGroup00-LogVol00 38G 738M 37G 2% /

уменьшить том под / до 8G
выделить том под /home
выделить том под /var
/var - сделать в mirror
/home - сделать том для снэпшотов
прописать монтирование в fstab
попробовать с разными опциями и разными файловыми системами ( на выбор)
- сгенерить файлы в /home/
- снять снэпшот
- удалить часть файлов
- восстановится со снэпшота
- залоггировать работу можно с помощью утилиты script

'*' на нашей куче дисков попробовать поставить btrfs/zfs - с кешем, снэпшотами - разметить здесь каталог /opt

## **Выполнено:**

1. [Протокол работы по основному заданию](typescript.main)

2. [Протокол работы по доп. заданию](typescript.star)

pvcreate /dev/sdb
vgcreate vg_opt /dev/sdb
lvcreate -n lv_opt -l +100%FREE /dev/vg_opt
mkfs.btrfs /dev/vg_opt/lv_opt
mount /dev/vg_opt/lv_opt /opt
btrfs sub create /opt/volume
btrfs subvolume show /opt
btrfs subvolume list /opt/
touch /opt/volume/file{1..20}
btrfs sub snapshot /opt/volume /opt/volume-snap
btrfs subvolume list /opt/
rm -f /opt/volume/file{11..20}
cd /opt
btrfs sub delete volume
mv volume-snap volume

