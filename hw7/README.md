# **Домашнее задание №7: Дистрибьюция софта**

## **Задание:**
Размещаем свой RPM в своем репозитории
1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
2) создать свой репо и разместить там свой RPM
реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо

* реализовать дополнительно пакет через docker

Критерии оценки: 5 - есть репо и рпм
+1 - сделан еще и докер образ

## **Выполнено: (для проверки достаточно использовать [Vagrantfile](Vagrantfile))**

### **1.Создать свой RPM пакет (nginx c поддержкой openssl)**
- Установим необходимые пакеты
```bash
yum install -y \
redhat-lsb-core \
wget \
rpmdevtools \
rpm-build \
createrepo \
yum-utils \
gcc
```
- Загрузим SRPM пакет NGINX:
```
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm
```
- Установим SRC пакет. При установке такого пакета в домашней директории создается древо каталогов для
сборки:
```
rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm
```
- Скачиваем и разархивируем последний исходник для openssl:
```
wget https://www.openssl.org/source/latest.tar.gz
tar -xvf latest.tar.gz
```
- Cтавим все зависимости чтобы в процессе сборки не было ошибок:
```
yum-builddep rpmbuild/SPECS/nginx.spec
```
- Правим сам [spec](nginx.spec) файл чтобы NGINX собирался с необходимыми нам опциями:
```
--with-openssl=/root/openssl-1.1.1d
```
По этой [ссылке](https://nginx.org/ru/docs/configure.html) можно посмотреть все доступные опции для сборки.
- Собственно, запускаем процесс сборки самого пакета:
```
rpmbuild -bb rpmbuild/SPECS/nginx.spec
```
- Проверяем результаты сборки:
```
[root@otuslinuxhw7 ~]# sudo -s
[root@otuslinuxhw7 ~]# ll ~/rpmbuild/RPMS/x86_64/
total 4364
-rw-r--r--. 1 root root 1974420 дек  5 06:59 nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
-rw-r--r--. 1 root root 2488224 дек  5 06:59 nginx-debuginfo-1.14.1-1.el7_4.ngx.x86_64.rpm
```
    
    
### **2.Создать свой репо и разместить там свой RPM**    
- Устанавливаем nginx из собранного rpm в п.1
```
yum localinstall -y rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
```
- Стартуем nginx и проверяем:
```
systemctl start nginx
systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since Чт 2019-12-05 06:59:03 UTC; 8h ago
     Docs: http://nginx.org/en/docs/
  Process: 20989 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 20990 (nginx)
   CGroup: /system.slice/nginx.service
           ├─20990 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx.conf
           └─21000 nginx: worker process

дек 05 06:59:03 otuslinuxhw7 systemd[1]: Starting nginx - high performance web server...
дек 05 06:59:03 otuslinuxhw7 systemd[1]: PID file /var/run/nginx.pid not readable (yet?) after start.
дек 05 06:59:03 otuslinuxhw7 systemd[1]: Started nginx - high performance web server.

-Создаем свой репозиторий и добавляем два пакета:

```
mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm \
-O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
createrepo /usr/share/nginx/html/repo/
```
-Для прозрачности настроим в NGINX доступ к листингу каталога:
В location / в файле [/etc/nginx/conf.d/default.conf]{default.conf} добавим директиву autoindex on.
В результате location будет выглядеть так:
```
location / {
root /usr/share/nginx/html;
index index.html index.htm;
***autoindex on;***
}
```




[root@otuslinuxhw7 ~]# curl -a http://localhost/repo/
<html>
<head><title>Index of /repo/</title></head>
<body bgcolor="white">
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          05-Dec-2019 15:27                   -
<a href="nginx-1.14.1-1.el7_4.ngx.x86_64.rpm">nginx-1.14.1-1.el7_4.ngx.x86_64.rpm</a>                05-Dec-2019 06:59             1974420
<a href="percona-release-0.1-6.noarch.rpm">percona-release-0.1-6.noarch.rpm</a>                   13-Jun-2018 06:34               14520
</pre><hr></body>
</html>
[root@otuslinuxhw7 ~]# yum list --showduplicates | grep otus
nginx.x86_64                                1:1.14.1-1.el7_4.ngx       otus
percona-release.noarch                      0.1-6                      otus
```
