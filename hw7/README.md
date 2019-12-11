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
```

- Создаем свой репозиторий и добавляем два пакета:

```
mkdir /usr/share/nginx/html/repo
cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm \
-O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
createrepo /usr/share/nginx/html/repo/
```
- Для прозрачности настроим в NGINX доступ к листингу каталога:
В location / в файле [/etc/nginx/conf.d/default.conf](default.conf) добавим директиву autoindex on.
В результате location будет выглядеть так:
```
location / {
root /usr/share/nginx/html;
index index.html index.htm;
autoindex on;
}
```
- Проверяем синтаксис и перезапускаем NGINX:
```
nginx -t
nginx -s reload
```
- Проверяем работу репозитория:
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
````
- Добавляем его в перечень локальных репозиториев:
```
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
```

- Проверяем:
```
yum repolist enabled | grep otus
[root@otuslinuxhw7 ~]# yum list --showduplicates | grep otus
nginx.x86_64                                1:1.14.1-1.el7_4.ngx       otus
percona-release.noarch                      0.1-6                      otus
```

- Ставим percona-release из локального репозитория:
```
yum install percona-release -y
Loaded plugins: fastestmirror
Loading mirror speeds from cached hostfile
 * base: dedic.sh
 * extras: dedic.sh
 * updates: mirror.docker.ru
Resolving Dependencies
--> Running transaction check
---> Package percona-release.noarch 0:0.1-6 will be installed
--> Finished Dependency Resolution

Dependencies Resolved

=====================================================================================================================================================================================================
 Package                                                Arch                                          Version                                      Repository                                   Size
=====================================================================================================================================================================================================
Installing:
 percona-release                                        noarch                                        0.1-6                                        otus                                         14 k

Transaction Summary
=====================================================================================================================================================================================================
Install  1 Package

Total download size: 14 k
Installed size: 16 k
Downloading packages:
No Presto metadata available for otus
percona-release-0.1-6.noarch.rpm                                                                                                                                              |  14 kB  00:00:00
Running transaction check
Running transaction test
Transaction test succeeded
Running transaction
  Installing : percona-release-0.1-6.noarch                                                                                                                                                      1/1
  Verifying  : percona-release-0.1-6.noarch                                                                                                                                                      1/1

Installed:
  percona-release.noarch 0:0.1-6

Complete!
```

3. Реализация дополнительно пакет через docker

- Создаем [Dockerfile](Dockerfile)

- Создаем Image

```
[root@4otus hw7]# docker build -t stump773/my-nginx-ssl-image:latest .
Sending build context to Docker daemon 2.026 MB
Step 1/6 : FROM centos:centos7
---> 5e35e350aded
Step 2/6 : LABEL MAINTAINER "stump773@gmail.com"
---> Using cache
---> a350eac119bb
Step 3/6 : COPY ./nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
--> Using cache
---> 2f5c00fe2bc2
Step 4/6 : RUN yum localinstall -y /nginx-1.14.1-1.el7_4.ngx.x86_64.rpm -y && rm -rf /nginx-1.14.1-1.el7_4.ngx.x86_64.rpm && yum clean packages -y
---> Using cache
---> 1e3799845830
Step 5/6 : EXPOSE 80
---> Running in 629d2755d99a
---> a24b5e54907f
Removing intermediate container 629d2755d99a
Step 6/6 : CMD nginx -g daemon off;
---> Running in 33169be9d19a
---> fbdb8a159f65
Removing intermediate container 33169be9d19a
Successfully built fbdb8a159f65
```       

- Запускаем контейнер и проверяем
```
[root@4otus hw7]# docker run -d -p 80:80 stump773/my-nginx-ssl-image
7b581b463f0bb60421b7b88ff91a6e3cf9a80cdea84523481424b9750876f00b
[root@4otus hw7]# docker ps
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                NAMES
7b581b463f0b        stump773/my-nginx-ssl-image   "nginx -g 'daemon ..."   10 seconds ago      Up 9 seconds        0.0.0.0:80->80/tcp   clever_hamilton
[root@4otus hw7]# ss -tnulp | grep 80
tcp    LISTEN     0      128    [::]:80                 [::]:*                   users:(("docker-proxy-cu",pid=24616,fd=4))
[root@4otus hw7]# curl localhost
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```

-  Выкладываем собранный [образ](https://hub.docker.com/repository/docker/stump773/my-nginx-ssl-image) в Docker Hub 
```
[root@4otus hw7]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username (stump773):
Password:
Login Succeeded
[root@4otus hw7]# docker push stump773/my-nginx-ssl-image
The push refers to a repository [docker.io/stump773/my-nginx-ssl-image]
1e9dc618d129: Pushed
6b7c9a54a4d8: Pushed
77b174a6a187: Mounted from library/centos
latest: digest: sha256:4ec9a043d41de2635696c2002b5082f7b0a6cdce676bf5355c776cb809ebe1aa size: 952
```

