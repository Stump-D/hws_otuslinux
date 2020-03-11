# **Домашнее задание №19: Мосты, туннели и VPN.**

## **Задание:**
1. Между двумя виртуалками поднять vpn в режимах
- tun
- tap
Прочуствовать разницу.

2. Поднять RAS на базе OpenVPN с клиентскими сертификатами, подключиться с локальной машины на виртуалку

3*. Самостоятельно изучить, поднять ocserv и подключиться с хоста к виртуалке

## **Выполнено:**
1. Проверяем, что в файле group_vars\all.yml переменной net_dev присвоено значение **tap** (Layer2)

2. Поднимаем стенд ```vagrant up``` с машинами :

- server
- client

3. На openvpn сервере запускаем iperf3 в режиме сервера
```
[vagrant@server ~]$ iperf3 -s &
[1] 25930
[vagrant@server ~]$ -----------------------------------------------------------
Server listening on 5201
-----------------------------------------------------------
```
4. На openvpn клиенте запускаем iperf3 в режиме клиента и замеряем
скорость в туннеле:
```
[vagrant@client ~]$ iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 54958 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.00   sec   125 MBytes   210 Mbits/sec   22    378 KBytes
[  4]   5.00-10.00  sec   122 MBytes   204 Mbits/sec   37    293 KBytes
[  4]  10.00-15.00  sec   126 MBytes   212 Mbits/sec    0    475 KBytes
[  4]  15.00-20.01  sec   126 MBytes   211 Mbits/sec   25    458 KBytes
[  4]  20.01-25.00  sec   126 MBytes   211 Mbits/sec   44    245 KBytes
[  4]  25.00-30.00  sec   126 MBytes   211 Mbits/sec   22    339 KBytes
[  4]  30.00-35.01  sec   126 MBytes   211 Mbits/sec    1    482 KBytes
[  4]  35.01-40.00  sec   125 MBytes   211 Mbits/sec   57    297 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec  1002 MBytes   210 Mbits/sec  208             sender
[  4]   0.00-40.00  sec  1001 MBytes   210 Mbits/sec                  receiver

iperf Done.
```

5. Меняем в файле group_vars\all.yml значение переменной net_dev на **tun** (Layer3) и 
выполняем провижн стенда ```vagrant provision```

6. Проверяем на client:
```
[vagrant@client ~]$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group defaul                                                                             t qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP gr                                                                             oup default qlen 1000
    link/ether 52:54:00:8a:fe:e6 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic eth0
       valid_lft 76263sec preferred_lft 76263sec
    inet6 fe80::5054:ff:fe8a:fee6/64 scope link
       valid_lft forever preferred_lft forever
3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP gr                                                                             oup default qlen 1000
    link/ether 08:00:27:98:f5:a2 brd ff:ff:ff:ff:ff:ff
    inet 192.168.10.20/24 brd 192.168.10.255 scope global noprefixroute eth1
       valid_lft forever preferred_lft forever
    inet6 fe80::a00:27ff:fe98:f5a2/64 scope link
       valid_lft forever preferred_lft forever
6: tun0: <POINTOPOINT,MULTICAST,NOARP,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast sta                                                                             te UNKNOWN group default qlen 100
    link/none
    inet 10.10.10.2/24 brd 10.10.10.255 scope global tun0
       valid_lft forever preferred_lft forever
    inet6 fe80::c479:d370:a284:e804/64 scope link flags 800
       valid_lft forever preferred_lft forever
[vagrant@client ~]$  iperf3 -c 10.10.10.1 -t 40 -i 5
Connecting to host 10.10.10.1, port 5201
[  4] local 10.10.10.2 port 54962 connected to 10.10.10.1 port 5201
[ ID] Interval           Transfer     Bandwidth       Retr  Cwnd
[  4]   0.00-5.01   sec   127 MBytes   213 Mbits/sec   20    453 KBytes
[  4]   5.01-10.00  sec   127 MBytes   213 Mbits/sec   26    411 KBytes
[  4]  10.00-15.00  sec   126 MBytes   212 Mbits/sec   44    340 KBytes
[  4]  15.00-20.00  sec   126 MBytes   211 Mbits/sec  164    408 KBytes
[  4]  20.00-25.00  sec   126 MBytes   211 Mbits/sec   15    437 KBytes
[  4]  25.00-30.01  sec   127 MBytes   213 Mbits/sec   22    448 KBytes
[  4]  30.01-35.00  sec   127 MBytes   213 Mbits/sec   33    370 KBytes
[  4]  35.00-40.00  sec   128 MBytes   214 Mbits/sec   22    378 KBytes
- - - - - - - - - - - - - - - - - - - - - - - - -
[ ID] Interval           Transfer     Bandwidth       Retr
[  4]   0.00-40.00  sec  1013 MBytes   213 Mbits/sec  346             sender
[  4]   0.00-40.00  sec  1012 MBytes   212 Mbits/sec                  receiver

iperf Done.
```

Большой разницы в скорости не обнаруживается, только при tun больше Retr в 1.5 раза.
