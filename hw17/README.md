# **Домашнее задание №17: Сетевые пакеты. VLAN'ы. LACP.**

## **Задание:**
строим бонды и вланы
в Office1 в тестовой подсети появляется сервера с доп интерфесами и адресами
в internal сети testLAN
- testClient1 - 10.10.10.254
- testClient2 - 10.10.10.254
- testServer1- 10.10.10.1
- testServer2- 10.10.10.1

равести вланами
testClient1 <-> testServer1
testClient2 <-> testServer2

между centralRouter и inetRouter
"пробросить" 2 линка (общая inernal сеть) и объединить их в бонд
проверить работу c отключением интерфейсов

для сдачи - вагрант файл с требуемой конфигурацией
Разворачиваться конфигурация должна через ансибл

![Схема сети:](network23.png)


## **Выполнено:**

1. Поднимаем стенд ```vagrnt up``` с машинами :
- inetRouter                running (virtualbox)
- centralRouter             running (virtualbox)
- testServer1               running (virtualbox)
- testClient1               running (virtualbox)
- testServer2               running (virtualbox)
- testClient2               running (virtualbox)

2. Запускаем плейбук:
```
[root@4otus hw17]# ansible-playbook playbook.yml

```
PLAY [install needed network manager libs] **********************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [testServer2]
ok: [testServer1]
ok: [testClient1]
ok: [centralRouter]
ok: [testClient2]
ok: [inetRouter]

TASK [install needed network manager libs] **********************************************************************************************************
ok: [testServer1] => (item=NetworkManager-glib)
ok: [testClient1] => (item=NetworkManager-glib)
ok: [centralRouter] => (item=NetworkManager-glib)
ok: [testServer2] => (item=NetworkManager-glib)
ok: [testClient2] => (item=NetworkManager-glib)
ok: [testServer1] => (item=libnm-qt-devel.x86_64)
ok: [testServer2] => (item=libnm-qt-devel.x86_64)
ok: [centralRouter] => (item=libnm-qt-devel.x86_64)
ok: [testClient1] => (item=libnm-qt-devel.x86_64)
ok: [testClient2] => (item=libnm-qt-devel.x86_64)
ok: [testServer1] => (item=nm-connection-editor.x86_64)
ok: [centralRouter] => (item=nm-connection-editor.x86_64)
ok: [testClient1] => (item=nm-connection-editor.x86_64)
ok: [testServer2] => (item=nm-connection-editor.x86_64)
ok: [testClient2] => (item=nm-connection-editor.x86_64)
ok: [testServer1] => (item=libsemanage-python)
ok: [testClient1] => (item=libsemanage-python)
ok: [centralRouter] => (item=libsemanage-python)
ok: [testServer2] => (item=libsemanage-python)
ok: [testClient2] => (item=libsemanage-python)
ok: [testServer1] => (item=policycoreutils-python)
ok: [testClient1] => (item=policycoreutils-python)
ok: [centralRouter] => (item=policycoreutils-python)
ok: [testServer2] => (item=policycoreutils-python)
ok: [testClient2] => (item=policycoreutils-python)
ok: [inetRouter] => (item=NetworkManager-glib)
ok: [inetRouter] => (item=libnm-qt-devel.x86_64)
ok: [inetRouter] => (item=nm-connection-editor.x86_64)
ok: [inetRouter] => (item=libsemanage-python)
ok: [inetRouter] => (item=policycoreutils-python)

PLAY [Isolated Config| testClients & testServers Network Configuration] *****************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [testClient2]
ok: [testServer1]
ok: [testClient1]
ok: [testServer2]

TASK [Try to set vlan&ip] ***************************************************************************************************************************
changed: [testClient1]
changed: [testClient2]
changed: [testServer2]
changed: [testServer1]

RUNNING HANDLER [restart_network] *******************************************************************************************************************
changed: [testServer1]
changed: [testServer2]
changed: [testClient2]
changed: [testClient1]

RUNNING HANDLER [reload_network_interface] **********************************************************************************************************
changed: [testServer1]
changed: [testClient2]
changed: [testServer2]
changed: [testClient1]

PLAY [Routers Config| Routers Network Configuration] ************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [centralRouter]
ok: [inetRouter]

TASK [Add a Team connection with static IP configuration] *******************************************************************************************
changed: [inetRouter]
changed: [centralRouter]

TASK [Try to set runner for Team0] ******************************************************************************************************************
changed: [centralRouter]
changed: [inetRouter]

TASK [Try nmcli add team-slave] *********************************************************************************************************************
changed: [centralRouter] => (item={u'conn_name': u'eth1', u'ifname': u'eth1', u'master': u'Team0'})
changed: [inetRouter] => (item={u'conn_name': u'eth1', u'ifname': u'eth1', u'master': u'Team0'})
changed: [centralRouter] => (item={u'conn_name': u'eth2', u'ifname': u'eth2', u'master': u'Team0'})
changed: [inetRouter] => (item={u'conn_name': u'eth2', u'ifname': u'eth2', u'master': u'Team0'})

RUNNING HANDLER [restart_network] *******************************************************************************************************************
changed: [inetRouter]
changed: [centralRouter]

RUNNING HANDLER [reload_network_interface] **********************************************************************************************************
changed: [centralRouter]
changed: [inetRouter]

PLAY RECAP ******************************************************************************************************************************************
centralRouter              : ok=8    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
inetRouter                 : ok=8    changed=5    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testClient1                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testClient2                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testServer1                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testServer2                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


3. Проверяем работу интерфейса Team0:
```
[root@4otus hw17]# vagrant ssh inetRouter
[root@inetRouter vagrant]# ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 85990sec preferred_lft 85990sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master Team0 state UP group default qlen 1000
    link/ether 08:00:27:3e:be:85 brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master Team0 state UP group default qlen 1000
    link/ether 08:00:27:3e:be:85 brd ff:ff:ff:ff:ff:ff
5: Team0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:3e:be:85 brd ff:ff:ff:ff:ff:ff
    inet 192.168.255.1/30 brd 192.168.255.3 scope global noprefixroute Team0
       valid_lft forever preferred_lft forever
    inet6 fe80::4b6c:8d4c:8f7e:4a6a/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
[root@inetRouter vagrant]# ping 192.168.255.2
PING 192.168.255.2 (192.168.255.2) 56(84) bytes of data.
64 bytes from 192.168.255.2: icmp_seq=1 ttl=64 time=0.255 ms
64 bytes from 192.168.255.2: icmp_seq=2 ttl=64 time=0.351 ms
64 bytes from 192.168.255.2: icmp_seq=3 ttl=64 time=0.370 ms
64 bytes from 192.168.255.2: icmp_seq=4 ttl=64 time=0.350 ms
...


[root@4otus hw17]# vagrant ssh centralRouter
Last login: Sat Feb 29 11:04:53 2020 from 10.0.2.2
[vagrant@centralRouter ~]$ sudo -s
[root@centralRouter vagrant]# nmcli conn show
NAME                UUID                                  TYPE      DEVICE
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
Team0               83e4597e-8c7c-4f5c-8b8f-305f5071d670  team      Team0
eth1                67818408-f2cb-4311-8902-856af8eba7b8  ethernet  eth1
eth2                396bf238-2f18-465e-b0ff-cf09d04629b7  ethernet  eth2
Wired connection 1  32397fea-db40-3fdd-8a74-1e1fd9277266  ethernet  --

[root@centralRouter vagrant]# tcpdump -nvvv -iTeam0 icmp
tcpdump: listening on Team0, link-type EN10MB (Ethernet), capture size 262144 bytes
12:03:53.128996 IP (tos 0x0, ttl 64, id 19612, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 6461, seq 237, length 64
12:03:53.129027 IP (tos 0x0, ttl 64, id 5848, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 6461, seq 237, length 64
12:03:54.130791 IP (tos 0x0, ttl 64, id 19921, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 6461, seq 238, length 64
12:03:54.130816 IP (tos 0x0, ttl 64, id 6716, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 6461, seq 238, length 64
12:03:55.134200 IP (tos 0x0, ttl 64, id 20595, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 6461, seq 239, length 64
12:03:55.134223 IP (tos 0x0, ttl 64, id 7455, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 6461, seq 239, length 64
    
[root@centralRouter vagrant]#  nmcli connection down eth1
Connection 'eth1' successfully deactivated (D-Bus active path: /org/freedesktop/NetworkManager/ActiveConnection/3)

```                        