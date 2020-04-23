# **Домашнее задание №27: PostgreSQL.**

## **Задание:**
PostgreSQL
- Настроить hot_standby репликацию с использованием слотов
- Настроить правильное резервное копирование

Для сдачи работы присылаем ссылку на репозиторий, в котором должны обязательно быть Vagranfile и плейбук Ansible, конфигурационные файлы postgresql.conf, pg_hba.conf и recovery.conf, а так же конфиг barman, либо скрипт резервного копирования. Команда "vagrant up" должна поднимать машины с настроенной репликацией и резервным копированием. Рекомендуется в README.md файл вложить результаты (текст или скриншоты) проверки работы репликации и резервного копирования.

## **Выполнено:**

1. Поднимаем стенд:
```
vagrant up
```

2. Запускаем плейбук:
```
ansible-playbook playbook.yml
```

3. Проверяем созданные слоты:
```
[root@master vagrant]# su postgres
bash-4.2$ psql
could not change directory to "/home/vagrant": Permission denied
psql (11.7)
Type "help" for help.

postgres=# \x
Expanded display is on.
postgres=# select * from pg_replication_slots;
-[ RECORD 1 ]-------+-------------
slot_name           | standby_slot
plugin              |
slot_type           | physical
datoid              |
database            |
temporary           | f
active              | t
active_pid          | 7532
xmin                |
catalog_xmin        |
restart_lsn         | 0/12000060
confirmed_flush_lsn |
-[ RECORD 2 ]-------+-------------
slot_name           | barman
plugin              |
slot_type           | physical
datoid              |
database            |
temporary           | f
active              | t
active_pid          | 7539
xmin                |
catalog_xmin        |
restart_lsn         | 0/12000000
confirmed_flush_lsn |
```

4. Проверяем статус репликации:
```
postgres=# select * from pg_stat_replication;
-[ RECORD 1 ]----+------------------------------
pid              | 7532
usesysid         | 16384
usename          | replica
application_name | walreceiver
client_addr      | 192.168.11.151
client_hostname  |
client_port      | 43820
backend_start    | 2020-04-23 13:39:19.750612+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/12000060
write_lsn        | 0/12000060
flush_lsn        | 0/12000060
replay_lsn       | 0/12000060
write_lag        |
flush_lag        |
replay_lag       |
sync_priority    | 0
sync_state       | async
-[ RECORD 2 ]----+------------------------------
pid              | 7539
usesysid         | 16386
usename          | streaming_barman
application_name | barman_receive_wal
client_addr      | 192.168.11.152
client_hostname  |
client_port      | 34464
backend_start    | 2020-04-23 13:40:02.371581+00
backend_xmin     |
state            | streaming
sent_lsn         | 0/12000060
write_lsn        | 0/12000060
flush_lsn        | 0/12000000
replay_lsn       |
write_lag        | 00:00:06.279107
flush_lag        | 00:02:17.396854
replay_lag       | 00:03:22.15359
sync_priority    | 0
sync_state       | async

```


5. Проверяем статус бэкапа: 
```
[root@backup vagrant]# su barman
bash-4.2$ barman check master
Server master:
        PostgreSQL: OK
        is_superuser: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 0 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK (no system Id stored on disk)
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        continuous archiving: OK
        archiver errors: OK

```


6. Ссоздаем первый бэкап через streaming protocol
```
bash-4.2$ barman backup master --wait
Starting backup using postgres method for server master in /var/lib/barman/master/base/20200423T134524
Backup start at LSN: 0/12000060 (000000010000000000000012, 00000060)
Starting backup copy via pg_basebackup for 20200423T134524
Copy done (time: 3 seconds)
Finalising the backup.
This is the first backup for server master
WAL segments preceding the current backup have been found:
        000000010000000000000011 from server master has been removed
Backup size: 302.6 MiB
Backup end at LSN: 0/14000000 (000000010000000000000013, 00000000)
Backup completed (start time: 2020-04-23 13:45:24.890960, elapsed time: 3 seconds)
Waiting for the WAL file 000000010000000000000013 from server 'master'
Processing xlog segments from streaming for master
        000000010000000000000012
Processing xlog segments from streaming for master
        000000010000000000000013
bash-4.2$ barman check master
Server master:
        PostgreSQL: OK
        is_superuser: OK
        PostgreSQL streaming: OK
        wal_level: OK
        replication slot: OK
        directories: OK
        retention policy settings: OK
        backup maximum age: OK (no last_backup_maximum_age provided)
        compression settings: OK
        failed backups: OK (there are 0 failed backups)
        minimum redundancy requirements: OK (have 1 backups, expected at least 0)
        pg_basebackup: OK
        pg_basebackup compatible: OK
        pg_basebackup supports tablespaces mapping: OK
        systemid coherence: OK
        pg_receivexlog: OK
        pg_receivexlog compatible: OK
        receive-wal running: OK
        archive_mode: OK
        archive_command: OK
        continuous archiving: OK
        archiver errors: OK

```
Полезное:
```
cat barman.conf | egrep -v '^;|^$' > barman.conf.j2
```
