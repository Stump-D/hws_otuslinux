# **Домашнее задание №4: Загрузка системы**

## **Задание:**
Работа с загрузчиком
1. Попасть в систему без пароля несколькими способами
2. Установить систему с LVM, после чего переименовать VG
3. Добавить модуль в initrd

4(*). Сконфигурировать систему без отдельного раздела с /boot, а только с LVM
Репозиторий с пропатченым grub: https://yum.rumyantsev.com/centos/7/x86_64/
PV необходимо инициализировать с параметром --bootloaderareasize 1m
Критерии оценки: Описать действия, описать разницу между методами получения шелла в процессе загрузки.
Где получится - используем script, где не получается - словами или копипастой описываем действия.

## **Выполнено:**

### 1. Попадаем в систему без пароля несколькими способами:

#### Способ 1. init=/bin/sh
В конце строки начинающейся с linux16 добавляем init=/bin/sh (т.е. сообщаем ядру запустить /bin/sh как первый процесс с PID=1)и нажимаем сtrl-x для загрузки в систему.

![Screen 1.1](./jpg/1.1.jpg)
![Screen 1.2](./jpg/1.2.jpg)
![Screen 1.3](./jpg/1.3.jpg)
    
Перемонтируем корневую систему в режиме Read-Write с проверкой
```bash
    mount -o remount,rw /
    mount | grep root
```

#### Способ 2. Через initrd, rd.break.
rd.break -  даем инструкцию initrd запустить emergency mode и sh перед pivot_root()
![Screen 2.1](./jpg/2.1.jpg)

Попадаем в emergency mode

![Screen 2.2](./jpg/2.2.jpg)

Выполняем:
```bash
mount -o remount,rw /sysroot
chroot /sysroot
passwd root
touch /.autorelabel
```
![Screen 2.3](./jpg/2.3.jpg)

Создание .autorelabel сообщает SELinux о необходимости запуска в initrd процесса restorecon(восстановления контекста) при последующей перезагрузке.


#### Способ 3. rw init=/sysroot/bin/sh

![Screen 3.1](./jpg/3.1.jpg)

Наблюдаем в журнале /run/initramfs/rdsosreport.txt, что initrd не удалось запустить init=/sysroot/sysroot/bin/sh и система справедливо решила провалиться в Emergency Mode

![Screen 3.2](./jpg/3.2.jpg)
![Screen 3.3](./jpg/3.3.jpg)


### 2. Установливаем систему с LVM, после чего переименовываем VG

Смотрим текущее состояние системы и переименовываем Volume Group:
![Screen 22.1](./jpg/22.1.jpg)

Правим [/etc/fstab](txt/fstab), [/etc/default/grub](txt/grub), [/boot/grub2/grub.cfg](txt/grub.cfg)

Пересоздаем initrd image, чтобы он знал новое название Volume Group
```bash
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
```
![Screen 22.2](./jpg/22.2.jpg)

Перегружаемся и проверяем:

![Screen 22.3](./jpg/22.3.jpg)

### 3. Добавляем модуль в initrd


```bash
#Создаем каталог для хранения модулей
mkdir /usr/lib/dracut/modules.d/01test 
cd /usr/lib/dracut/modules.d/01test

#Скачиваем скрипты
wget -O module-setup.sh https://gist.githubusercontent.com/lalbrekht/e51b2580b47bb5a150bd1a002f16ae85/raw/80060b7b300e193c187bbcda4d8fdf0e1c066af9/gistfile1.txt
wget -O test.sh https://gist.githubusercontent.com/lalbrekht/ac45d7a6c6856baea348e64fac43faf0/raw/69598efd5c603df310097b52019dc979e2cb342d/gistfile1.txt

#Пересобираем образ initrd
dracut -f -v
#Можно еще так:
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

#Проверяем
lsinitrd -m /boot/initramfs-$(uname -r).img | grep test
```
 
![Screen 33.1](./jpg/33.1.jpg)

Перегружаемся и руками выключаем опции rghb и quiet чтобы увидеть вывод

![Screen 33.2](./jpg/33.2.jpg)

Результат работы [test.sh](test.sh)

![Screen 33.3](./jpg/33.3.jpg)