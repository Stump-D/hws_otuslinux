Скрипт запущен Пн 18 ноя 2019 19:28:56
]0;root@4otus:~/otuslinux/hws_otuslinux/hw3[?1034h[root@4otus hw3]# vagrant ssh
Last login: Mon Nov 18 16:25:24 2019 from 10.0.2.2
]0;vagrant@lvm:~[?1034h[vagrant@lvm ~]$ sudo -s
]0;root@lvm:/home/vagrant[?1034h[root@lvm vagrant]# lsblk 
NAME                       MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda                          8:0    0   40G  0 disk 
├─sda1                       8:1    0    1M  0 part 
├─sda2                       8:2    0    1G  0 part /boot
└─sda3                       8:3    0   39G  0 part 
  ├─VolGroup00-LogVol00    253:0    0    8G  0 lvm  /
  ├─VolGroup00-LogVol01    253:1    0  1.5G  0 lvm  [SWAP]
  └─VolGroup00-LogVol_Home 253:2    0    2G  0 lvm  /home
sdb                          8:16   0   10G  0 disk 
sdc                          8:32   0    2G  0 disk 
├─vg_var-lv_var_rmeta_0    253:3    0    4M  0 lvm  
│ └─vg_var-lv_var          253:8    0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_0   253:4    0  952M  0 lvm  
  └─vg_var-lv_var          253:8    0  952M  0 lvm  /var
sdd                          8:48   0    1G  0 disk 
├─vg_var-lv_var_rmeta_1    253:6    0    4M  0 lvm  
│ └─vg_var-lv_var          253:8    0  952M  0 lvm  /var
└─vg_var-lv_var_rimage_1   253:7    0  952M  0 lvm  
  └─vg_var-lv_var          253:8    0  952M  0 lvm  /var
sde                          8:64   0    1G  0 disk 
]0;root@lvm:/home/vagrant[root@lvm vagrant]# #pvcreate /dev/sdc[C[1P[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[Kb
  Physical volume "/dev/sdb" successfully created.
]0;root@lvm:/home/vagrant[root@lvm vagrant]# vgcreate vg_var /dev/sdc /dev/sdd[1P[1P[1P[1@o[1@p[1@t[C[C[C[C[C[C[C[C[1P[1P[1P /dev/sdd[1P/dev/sdd[1Pdev/sdd[1Pev/sdd[1Pv/sdd[1P/sdd[1Psdd[1Pdd[C[K[Ksdb
  Volume group "vg_opt" successfully created
]0;root@lvm:/home/vagrant[root@lvm vagrant]# vcreate -n lv_root -l +100%FREE /dev/vg_root[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[1@l[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[1P[1P[1P[1P[1@o[1@p[1@r[1P[1@t[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[K[K[K[Kopt
WARNING: btrfs signature detected on /dev/vg_opt/lv_opt at offset 65600. Wipe it? [y/n]: y
  Wiping btrfs signature on /dev/vg_opt/lv_opt.
  Logical volume "lv_opt" created.
]0;root@lvm:/home/vagrant[root@lvm vagrant]# mkfs.xfs /dev/vg_root/lv_root[1P /dev/vg_root/lv_root[1P /dev/vg_root/lv_root[1P /dev/vg_root/lv_rootb /dev/vg_root/lv_roott /dev/vg_root/lv_rootrfs /dev/vg_root/lv_root[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[K[K[K[K[K[K[K[K[K[K[K[Kopt/lv_opt 
btrfs-progs v4.9.1
See http://btrfs.wiki.kernel.org for more information.

Label:              (null)
UUID:               86a64a3a-7b5e-4ea7-9037-fa387bcf227b
Node size:          16384
Sector size:        4096
Filesystem size:    10.00GiB
Block group profiles:
  Data:             single            8.00MiB
  Metadata:         DUP             511.75MiB
  System:           DUP               8.00MiB
SSD detected:       no
Incompat features:  extref, skinny-metadata
Number of devices:  1
Devices:
   ID        SIZE  PATH
    1    10.00GiB  /dev/vg_opt/lv_opt

]0;root@lvm:/home/vagrant[root@lvm vagrant]# mot[Kunt /dev/vg_opt/lv_opt /opt
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs sub create /opt/volume
Create subvolume '/opt/volume'
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs subvolume show /opt
/opt
	Name: 			<FS_TREE>
	UUID: 			-
	Parent UUID: 		-
	Received UUID: 		-
	Creation time: 		-
	Subvolume ID: 		5
	Generation: 		7
	Gen at creation: 	0
	Parent ID: 		0
	Top level ID: 		0
	Flags: 			-
	Snapshot(s):
				volume
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs subvolume list /opt/
ID 257 gen 7 top level 5 path volume
]0;root@lvm:/home/vagrant[root@lvm vagrant]# touch /opt/volume/file{1..20}
]0;root@lvm:/home/vagrant[root@lvm vagrant]# ll /opt/volume/file[K[K[K[K
total 0
-rw-r--r--. 1 root root 0 Nov 18 16:33 file1
-rw-r--r--. 1 root root 0 Nov 18 16:33 file10
-rw-r--r--. 1 root root 0 Nov 18 16:33 file11
-rw-r--r--. 1 root root 0 Nov 18 16:33 file12
-rw-r--r--. 1 root root 0 Nov 18 16:33 file13
-rw-r--r--. 1 root root 0 Nov 18 16:33 file14
-rw-r--r--. 1 root root 0 Nov 18 16:33 file15
-rw-r--r--. 1 root root 0 Nov 18 16:33 file16
-rw-r--r--. 1 root root 0 Nov 18 16:33 file17
-rw-r--r--. 1 root root 0 Nov 18 16:33 file18
-rw-r--r--. 1 root root 0 Nov 18 16:33 file19
-rw-r--r--. 1 root root 0 Nov 18 16:33 file2
-rw-r--r--. 1 root root 0 Nov 18 16:33 file20
-rw-r--r--. 1 root root 0 Nov 18 16:33 file3
-rw-r--r--. 1 root root 0 Nov 18 16:33 file4
-rw-r--r--. 1 root root 0 Nov 18 16:33 file5
-rw-r--r--. 1 root root 0 Nov 18 16:33 file6
-rw-r--r--. 1 root root 0 Nov 18 16:33 file7
-rw-r--r--. 1 root root 0 Nov 18 16:33 file8
-rw-r--r--. 1 root root 0 Nov 18 16:33 file9
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs sub snapshot -r /opt/volume /opt/volume-snap
Create a readonly snapshot of '/opt/volume' in '/opt/volume-snap'
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs sub delete volume
ERROR: cannot access subvolume volume: No such file or directory
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs sub delete volume-sn[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[Kvagrant ssh
bash: vagrant: command not found
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs sub delete volume
ERROR: cannot access subvolume volume: No such file or directory
]0;root@lvm:/home/vagrant[root@lvm vagrant]# btrfs sub delete volume[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[K[Kcd /opt/
]0;root@lvm:/opt[root@lvm opt]# ll
total 0
drwxr-xr-x. 1 root root 222 Nov 18 16:33 [0m[01;34mvolume[0m
drwxr-xr-x. 1 root root 222 Nov 18 16:33 [01;34mvolume-snap[0m
]0;root@lvm:/opt[root@lvm opt]# llcd /opt/btrfs sub delete volume-snap/
Delete subvolume (no-commit): '/opt/volume-snap'
]0;root@lvm:/opt[root@lvm opt]# btrfs sub delete volume-snap/[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[Cll[Kcd /opt/btrfs sub delete volume[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[12Pvagrant sshbtrfs sub delete volume[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[Kbtrfs sub snapshot /opt/volume /opt/volume-snap
Create a snapshot of '/opt/volume' in '/opt/volume-snap'
]0;root@lvm:/opt[root@lvm opt]# btrfs subvolume list /opt/
ID 257 gen 9 top level 5 path volume
ID 259 gen 9 top level 5 path volume-snap
]0;root@lvm:/opt[root@lvm opt]# rm -f /opt/volume/file{11..20}
]0;root@lvm:/opt[root@lvm opt]# ll /opt/volume1[K
total 0
-rw-r--r--. 1 root root 0 Nov 18 16:33 file1
-rw-r--r--. 1 root root 0 Nov 18 16:33 file10
-rw-r--r--. 1 root root 0 Nov 18 16:33 file2
-rw-r--r--. 1 root root 0 Nov 18 16:33 file3
-rw-r--r--. 1 root root 0 Nov 18 16:33 file4
-rw-r--r--. 1 root root 0 Nov 18 16:33 file5
-rw-r--r--. 1 root root 0 Nov 18 16:33 file6
-rw-r--r--. 1 root root 0 Nov 18 16:33 file7
-rw-r--r--. 1 root root 0 Nov 18 16:33 file8
-rw-r--r--. 1 root root 0 Nov 18 16:33 file9
]0;root@lvm:/opt[root@lvm opt]# btrfs sub delete volume
Delete subvolume (no-commit): '/opt/volume'
]0;root@lvm:/opt[root@lvm opt]# mv vli[K[Kolume-snap/[K volume-snap/[K[K[K[K[K[K
]0;root@lvm:/opt[root@lvm opt]# mv volume-snap volume[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[2@btrfs sub delete[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[9Pll /opt/volume
total 0
-rw-r--r--. 1 root root 0 Nov 18 16:33 file1
-rw-r--r--. 1 root root 0 Nov 18 16:33 file10
-rw-r--r--. 1 root root 0 Nov 18 16:33 file11
-rw-r--r--. 1 root root 0 Nov 18 16:33 file12
-rw-r--r--. 1 root root 0 Nov 18 16:33 file13
-rw-r--r--. 1 root root 0 Nov 18 16:33 file14
-rw-r--r--. 1 root root 0 Nov 18 16:33 file15
-rw-r--r--. 1 root root 0 Nov 18 16:33 file16
-rw-r--r--. 1 root root 0 Nov 18 16:33 file17
-rw-r--r--. 1 root root 0 Nov 18 16:33 file18
-rw-r--r--. 1 root root 0 Nov 18 16:33 file19
-rw-r--r--. 1 root root 0 Nov 18 16:33 file2
-rw-r--r--. 1 root root 0 Nov 18 16:33 file20
-rw-r--r--. 1 root root 0 Nov 18 16:33 file3
-rw-r--r--. 1 root root 0 Nov 18 16:33 file4
-rw-r--r--. 1 root root 0 Nov 18 16:33 file5
-rw-r--r--. 1 root root 0 Nov 18 16:33 file6
-rw-r--r--. 1 root root 0 Nov 18 16:33 file7
-rw-r--r--. 1 root root 0 Nov 18 16:33 file8
-rw-r--r--. 1 root root 0 Nov 18 16:33 file9
]0;root@lvm:/opt[root@lvm opt]# logout
bash: logout: not login shell: use `exit'
]0;root@lvm:/opt[root@lvm opt]# exit
exit
]0;vagrant@lvm:~[vagrant@lvm ~]$ logout
Connection to 127.0.0.1 closed.
]0;root@4otus:~/otuslinux/hws_otuslinux/hw3[root@4otus hw3]# vagrant sshkill {5411,5413}ps -aux |grep script
root     15034  0.0  0.0 116372   908 pts/0    S+   19:28   0:00 [01;31m[Kscript[m[K -f
root     15036  0.0  0.0 116376   408 pts/0    S+   19:28   0:00 [01;31m[Kscript[m[K -f
root     15232  0.0  0.0 112732   964 pts/3    S+   19:38   0:00 grep --color=auto [01;31m[Kscript[m[K
]0;root@4otus:~/otuslinux/hws_otuslinux/hw3[root@4otus hw3]# ps -aux |grep script[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[C[9Pvagrant sshkill {5411,5413}[1P411,5413}[1P11,5413}[C[1P,5413}[1P,5413}1,5413}5,5413}0,5413}3,5413}4,5413}[C[1P413}[1P13}[1P3}[1P}1}5}0}3}6}