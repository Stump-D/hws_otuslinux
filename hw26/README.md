# **Домашнее задание №26: MySQL - бэкап, репликация, кластер.**

## **Задание:**
развернуть InnoDB кластер в docker
развернуть InnoDB кластер в docker
* в docker swarm

в качестве ДЗ принимает репозиторий с docker-compose
который по кнопке разворачивает кластер и выдает порт наружу

## **Выполнено:**

1.Настраиваем selinux для разрешения запуска scripts/setupCluster.js
```
semanage fcontext -l |grep mysql
chcon -t mysqld_exec_t ./scripts/setupCluster.js
```

либо привычным способом :)
```
setenforce 0
```


2. Поднимаем кластер
```
docker-compose up

....
mysql-shell_1     | Adding instances to the cluster...
mysql-shell_1     | Instances successfully added to the cluster.
mysql-shell_1     | InnoDB cluster deployed successfully.
mysql-server-3_1  | 2020-04-12T20:09:47.339195Z 18 [System] [MY-010597] [Repl] 'CHANGE MASTER TO FOR CHANNEL 'group_replication_recovery' executed'. Previous state master_host='d8fc95401101', master_port= 3306, master_log_file='', master_log_pos= 4, master_bind=''. New state master_host='<NULL>', master_port= 0, master_log_file='', master_log_pos= 4, master_bind=''.
hw26_mysql-shell_1 exited with code 0
```

3. Проверяем:

При необходимости ставим  mysql-shell:
```
rpm -i https://dev.mysql.com/get/mysql80-community-release-el7-1.noarch.rpm
yum install mysql-shell
```


Собственно запускаем сам mysql-shell
```
[root@4otus hw26]# mysqlsh -u root -pPass@Word -P6446 -h 127.0.0.1
MySQL Shell 8.0.19

Copyright (c) 2016, 2019, Oracle and/or its affiliates. All rights reserved.
Oracle is a registered trademark of Oracle Corporation and/or its affiliates.
Other names may be trademarks of their respective owners.

Type '\help' or '\?' for help; '\quit' to exit.
WARNING: Using a password on the command line interface can be insecure.
Creating a session to 'root@127.0.0.1:6446'
Fetching schema names for autocompletion... Press ^C to stop.
Your MySQL connection id is 141
Server version: 8.0.19 MySQL Community Server - GPL
No default schema selected; type \use <schema> to set one.
 MySQL  127.0.0.1:6446 ssl  JS > var cluster = dba.getCluster(); cluster.status()
WARNING: No cluster change operations can be executed because the installed metadata version 1.0.1 is lower than the version required by Shell which is version 2.0.0. Upgrade the metadata to remove this restriction. See \? dba.upgradeMetadata for additional details.
{
    "clusterName": "InnoDBCluster4Otus",
    "defaultReplicaSet": {
        "name": "default",
        "primary": "mysql-server-1:3306",
        "ssl": "REQUIRED",
        "status": "OK",
        "statusText": "Cluster is ONLINE and can tolerate up to ONE failure.",
        "topology": {
            "mysql-server-1:3306": {
                "address": "mysql-server-1:3306",
                "mode": "n/a",
                "readReplicas": {},
                "role": "HA",
                "shellConnectError": "MySQL Error 2005 (HY000): Unknown MySQL server host 'mysql-server-1' (2)",
                "status": "ONLINE",
                "version": "8.0.19"
            },
            "mysql-server-2:3306": {
                "address": "mysql-server-2:3306",
                "mode": "n/a",
                "readReplicas": {},
                "role": "HA",
                "shellConnectError": "MySQL Error 2005 (HY000): Unknown MySQL server host 'mysql-server-2' (2)",
                "status": "ONLINE",
                "version": "8.0.19"
            },
            "mysql-server-3:3306": {
                "address": "mysql-server-3:3306",
                "mode": "n/a",
                "readReplicas": {},
                "role": "HA",
                "shellConnectError": "MySQL Error 2005 (HY000): Unknown MySQL server host 'mysql-server-3' (2)",
                "status": "ONLINE",
                "version": "8.0.19"
            }
        },
        "topologyMode": "Single-Primary"
    },
    "groupInformationSourceMember": "e031bea179f2:3306"
}
```
