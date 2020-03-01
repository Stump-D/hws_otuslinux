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

1. Поднимаем стенд ```vagrant up``` с машинами :
- inetRouter                running (virtualbox)
- centralRouter             running (virtualbox)
- testServer1               running (virtualbox)
- testClient1               running (virtualbox)
- testServer2               running (virtualbox)
- testClient2               running (virtualbox)

2. Запускаем плейбук:
```
[root@4otus hw17]# ansible-playbook playbook.yml

PLAY [install needed network manager libs] **********************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [testClient2]
ok: [testClient1]
ok: [testServer2]
ok: [testServer1]
ok: [centralRouter]
ok: [inetRouter]

TASK [install needed network manager libs] **********************************************************************************************************
ok: [testClient1]
ok: [testServer2]
ok: [testServer1]
ok: [centralRouter]
ok: [testClient2]
ok: [inetRouter]

PLAY [Isolated Config| testClients & testServers Network Configuration] *****************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [testClient1]
ok: [testServer1]
ok: [testServer2]
ok: [testClient2]

TASK [Try to set vlan&ip] ***************************************************************************************************************************
changed: [testServer2]
changed: [testServer1]
changed: [testClient2]
changed: [testClient1]

RUNNING HANDLER [reload network interface] **********************************************************************************************************
changed: [testServer2]
changed: [testServer1]
changed: [testClient2]
changed: [testClient1]

RUNNING HANDLER [restart NetworkManager] ************************************************************************************************************
changed: [testClient2]
changed: [testClient1]
changed: [testServer1]
changed: [testServer2]

PLAY [centralRouter Config] *************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [centralRouter]

TASK [Try to set vlan centralRouter] ****************************************************************************************************************
changed: [centralRouter] => (item={u'ifname': u'eth3', u'vlan_id': 100, u'vlan_name': u'vlan100'})
changed: [centralRouter] => (item={u'ifname': u'eth3', u'vlan_id': 101, u'vlan_name': u'vlan101'})

RUNNING HANDLER [reload network interface] **********************************************************************************************************
changed: [centralRouter]

RUNNING HANDLER [restart NetworkManager] ************************************************************************************************************
changed: [centralRouter]

PLAY [Routers Config| Routers Network Configuration] ************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [inetRouter]
ok: [centralRouter]

TASK [Try nmcli add bond - conn_name only & ip4 gw4 mode] *******************************************************************************************
changed: [inetRouter] => (item={u'conn_name': u'Team0', u'mode': u'balance-rr', u'ip4': u'192.168.255.1/30'})
changed: [centralRouter] => (item={u'conn_name': u'Team0', u'mode': u'balance-rr', u'ip4': u'192.168.255.2/30'})

TASK [Try nmcli add bond-slave] *********************************************************************************************************************
changed: [inetRouter] => (item={u'conn_name': u'Team-Port0', u'ifname': u'eth1', u'master': u'Team0'})
changed: [centralRouter] => (item={u'conn_name': u'Team-Port0', u'ifname': u'eth1', u'master': u'Team0'})
changed: [inetRouter] => (item={u'conn_name': u'Team-Port1', u'ifname': u'eth2', u'master': u'Team0'})
changed: [centralRouter] => (item={u'conn_name': u'Team-Port1', u'ifname': u'eth2', u'master': u'Team0'})

RUNNING HANDLER [reload network interface] **********************************************************************************************************
changed: [inetRouter]
changed: [centralRouter]

RUNNING HANDLER [restart NetworkManager] ************************************************************************************************************
changed: [inetRouter]
changed: [centralRouter]

PLAY RECAP ******************************************************************************************************************************************
centralRouter              : ok=11   changed=7    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
inetRouter                 : ok=7    changed=4    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testClient1                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testClient2                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testServer1                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
testServer2                : ok=6    changed=3    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```


3. Проверяем работу интерфейса Team0:
```
[root@4otus hw17]# vagrant ssh inetRouter
Last login: Sun Mar  1 21:00:11 2020 from 10.0.2.2
[vagrant@inetRouter ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 86197sec preferred_lft 86197sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master Team0 state UP group default qlen 1000
    link/ether 08:00:27:25:14:2f brd ff:ff:ff:ff:ff:ff
4: eth2: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master Team0 state UP group default qlen 1000
    link/ether 08:00:27:25:14:2f brd ff:ff:ff:ff:ff:ff
5: Team0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether 08:00:27:25:14:2f brd ff:ff:ff:ff:ff:ff
    inet 192.168.255.1/30 brd 192.168.255.3 scope global noprefixroute Team0
       valid_lft forever preferred_lft forever
    inet6 fe80::16ea:8dab:623c:38fe/64 scope link noprefixroute
       valid_lft forever preferred_lft forever
[vagrant@inetRouter ~]$ ping  192.168.255.1
PING 192.168.255.1 (192.168.255.1) 56(84) bytes of data.
64 bytes from 192.168.255.1: icmp_seq=1 ttl=64 time=0.025 ms
64 bytes from 192.168.255.1: icmp_seq=2 ttl=64 time=0.032 ms
64 bytes from 192.168.255.1: icmp_seq=3 ttl=64 time=0.034 ms
64 bytes from 192.168.255.1: icmp_seq=4 ttl=64 time=0.038 ms

...

[root@4otus hw17]# vagrant ssh centralRouter
Last login: Sun Mar  1 21:05:20 2020 from 10.0.2.2
[vagrant@centralRouter ~]$ sudo -s
[root@centralRouter vagrant]# nmcli con show
NAME                UUID                                  TYPE      DEVICE
Wired connection 1  a8807067-7527-36f1-9b67-751ec709ee52  ethernet  eth3
vlan100             b89dd093-2b10-4cf8-bb51-45741d4b5bd5  vlan      eth3.100
vlan101             4e86b6ec-1787-4bf4-8862-46f13348e347  vlan      eth3.101
System eth0         5fb06bd0-0bb0-7ffb-45f1-d6edd65f3e03  ethernet  eth0
Team0               0e91292d-a7ed-45b0-b08c-664c7b8a46cc  bond      Team0
Team-Port0          0242f1cd-60c8-4552-a794-ef01ff0bac32  ethernet  eth1
Team-Port1          9ef782e9-f549-4a7c-8ca1-0dca0b502b2d  ethernet  eth2

[root@centralRouter vagrant]# tcpdump -nvvv -iTeam0 icmp
tcpdump: listening on Team0, link-type EN10MB (Ethernet), capture size 262144 bytes
21:07:45.339111 IP (tos 0x0, ttl 64, id 30681, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 7646, seq 1, length 64
21:07:45.339144 IP (tos 0x0, ttl 64, id 25827, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 7646, seq 1, length 64
21:07:46.339294 IP (tos 0x0, ttl 64, id 31425, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 7646, seq 2, length 64
21:07:46.339322 IP (tos 0x0, ttl 64, id 26437, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 7646, seq 2, length 64
21:07:47.339293 IP (tos 0x0, ttl 64, id 32233, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 7646, seq 3, length 64

[root@centralRouter vagrant]# ifdown eth2
Device 'eth2' successfully disconnected.

[root@centralRouter vagrant]# tcpdump -nvvv -iTeam0 icmp
tcpdump: listening on Team0, link-type EN10MB (Ethernet), capture size 262144 bytes
21:10:12.331214 IP (tos 0x0, ttl 64, id 4797, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 7649, seq 33, length 64
21:10:12.331245 IP (tos 0x0, ttl 64, id 15094, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 7649, seq 33, length 64
21:10:13.331217 IP (tos 0x0, ttl 64, id 5532, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 7649, seq 34, length 64
21:10:13.331247 IP (tos 0x0, ttl 64, id 15627, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 7649, seq 34, length 64
21:10:14.331219 IP (tos 0x0, ttl 64, id 5599, offset 0, flags [DF], proto ICMP (1), length 84)
    192.168.255.1 > 192.168.255.2: ICMP echo request, id 7649, seq 35, length 64
21:10:14.331254 IP (tos 0x0, ttl 64, id 16477, offset 0, flags [none], proto ICMP (1), length 84)
    192.168.255.2 > 192.168.255.1: ICMP echo reply, id 7649, seq 35, length 64

```                        

