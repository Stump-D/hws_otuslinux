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

