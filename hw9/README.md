# **Домашнее задание №9: Docker**

## **Цель: Разобраться с основами docker, с образа, эко системой docker в целом.**

## **Задание:**

Создайте свой кастомный образ nginx на базе alpine. После запуска nginx должен
отдавать кастомную страницу (достаточно изменить дефолтную страницу nginx)
Определите разницу между контейнером и образом
Вывод опишите в домашнем задании.
Ответьте на вопрос: Можно ли в контейнере собрать ядро?
Собранный образ необходимо запушить в docker hub и дать ссылку на ваш
репозитори

Задание со * (звездочкой)
Создайте кастомные образы nginx и php, объедините их в docker-compose.
После запуска nginx должен показывать php info.
Все собранные образы должны быть в docker hub


## **Выполнено:**

### **1. Создан  свой кастомный образ nginx на базе alpine.**

**- Для создания образа подготовлен следующий [Dockerfile](Dockerfile).**

**- Создаем образ**
```
[root@4otus hw9]# docker build -t stump773/my-nginx-image:0.2 --no-cache .
Sending build context to Docker daemon 184.3 kB
Step 1/6 : FROM alpine:3.10
 ---> 965ea09ff2eb
Step 2/6 : RUN set -x     && apk add --update nginx     && rm -rf /var/cache/apk/*     && ln -sf /dev/stdout /var/log/nginx/access.log     && ln -sf /dev/stderr /var/log/nginx/error.log
 ---> Running in b07efc38037b

+ apk add --update nginx
fetch http://dl-cdn.alpinelinux.org/alpine/v3.10/main/x86_64/APKINDEX.tar.gz
fetch http://dl-cdn.alpinelinux.org/alpine/v3.10/community/x86_64/APKINDEX.tar.gz
(1/2) Installing pcre (8.43-r0)
(2/2) Installing nginx (1.16.1-r1)
Executing nginx-1.16.1-r1.pre-install
Executing busybox-1.30.1-r2.trigger
OK: 7 MiB in 16 packages
+ rm -rf /var/cache/apk/APKINDEX.00740ba1.tar.gz /var/cache/apk/APKINDEX.d8b2a6f4.tar.gz
+ ln -sf /dev/stdout /var/log/nginx/access.log
+ ln -sf /dev/stderr /var/log/nginx/error.log
 ---> 6f0ffb4ab9a1
Removing intermediate container b07efc38037b
Step 3/6 : COPY default.conf /etc/nginx/conf.d/default.conf
 ---> 219ef1c3d6c9
Removing intermediate container 2d937f231a08
Step 4/6 : COPY nginx.conf /etc/nginx/nginx.conf
 ---> a83c167403eb
Removing intermediate container 849f459c1657
Step 5/6 : COPY index.html /usr/share/nginx/html/index.html
 ---> 6cfb6409d2c5
Removing intermediate container a2213f152a80
Step 6/6 : CMD nginx -g daemon off;
 ---> Running in 950a27e57e41
 ---> 3a820e3cf0ad
Removing intermediate container 950a27e57e41
Successfully built 3a820e3cf0ad
```        


**- Проверяем создание**
```
[root@4otus hw9]# docker images
REPOSITORY                          TAG                 IMAGE ID            CREATED             SIZE
stump773/my-nginx-image             0.2                 cb6d4196408b        2 minutes ago       7 MB
```

**- Проверяем работу**
```
[root@4otus hw9]# docker run -d -p 80:80 stump773/my-nginx-image:0.2
1afb712d28283d7921bff9c85d3eb64a3c6e072b98e3c166c15a38fbf9c6cb24
[root@4otus hw9]# docker ps
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                NAMES
1afb712d2828        stump773/my-nginx-image:0.2   "nginx -g 'daemon ..."   50 seconds ago      Up 50 seconds       0.0.0.0:80->80/tcp   gracious_wilson
[root@4otus hw9]# curl localhost
<html>
<head>
<title>Welcome Homework №9</title>
</head>
<body>
<h1>Welcome Homework №9 </h1>
</body>
</html>
```

**- Выкладываем в [Docker Hub](https://hub.docker.com/repository/docker/stump773/my-nginx-image)**
```
[root@4otus hw9]# docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username (stump773):
Password:
Login Succeeded
[root@4otus hw9]# docker push stump773/my-nginx-image:0.2
The push refers to a repository [docker.io/stump773/my-nginx-image]
d938a4c3ab50: Pushed
4055203e2596: Pushed
93543199c30d: Pushed
60d5785be836: Pushed
77cae8ab23bf: Layer already exists
0.2: digest: sha256:18e580dac0918f3843ff132d916771b97a1c70b820a77526dd220ac88533e63a size: 1359

```


### **2. Выводы про разницу между контейнером и образом:**
Образ докера являются основой контейнеров. Образ - это упорядоченная коллекция изменений корневой файловой системы и соответствующих параметров 
выполнения для использования в среде выполнения контейнера. 
Образ обычно содержит объединение многоуровневых файловых систем, расположенных друг на друге. Образ не имеет состояния и никогда не изменяется.
**Контейнер - это исполняемый(остановленный) экземпляр образа docker.** 
Контейнер Docker состоит из
- Docker образа 
- Среды выполнения
- Стандартного набора инструкций
Концепция заимствована из морских контейнеров, которые определяют стандарт для доставки товаров по всему миру. 
Docker определяет стандарт для отправки программного обеспечения.

Взято из [Docker Glossary](https://docs.docker.com/glossary/)

Хотелось бы еще добавить, что из одного образа можно запустить множество контейнеров.

### **3. Ответьте на вопрос: Можно ли в контейнере собрать ядро?**

- Собрать возможно - [https://github.com/moul/docker-kernel-builde](https://github.com/moul/docker-kernel-builder). 
 Загрузиться вряд ли получится )


### **Задание (*)**

- Создан [Dockerfile](./nginx-php-fpm/php-fpm/Dockerfile) для создания образа с php-fpm
- Создан [docker-compose.yml](./nginx-php-fpm/docker-compose.yml)
- Запускаем и проверяем
```
[root@4otus nginx-php-fpm]# docker-compose up

Starting nginxphpfpm_web_1 ... doneone
Attaching to nginxphpfpm_phpfpm_1, nginxphpfpm_web_1
phpfpm_1  | [12-Dec-2019 15:58:22] NOTICE: fpm is running, pid 1
phpfpm_1  | [12-Dec-2019 15:58:22] NOTICE: ready to handle connections
phpfpm_1  | 172.19.0.3 -  12/Dec/2019:15:58:31 +0000 "GET /index.php" 200
web_1     | 192.168.0.100 - - [12/Dec/2019:15:58:31 +0000] "GET / HTTP/1.1" 200 74303 "-" "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36" "-"
^CGracefully stopping... (press Ctrl+C again to force)
Stopping nginxphpfpm_phpfpm_1 ... done
Stopping nginxphpfpm_web_1    ... done
```

![Screen](./nginx-php-fpm/screen.jpg)

### ***Полезные команды:***
```
docker ps -a
docker inspect [OPTIONS] NAME|ID [NAME|ID...]
docker exec -it NAME|ID /bin/sh
docker logs NAME|ID
docker rm $(docker ps -aq)
docker run NAME --restart always#стартовать контейнер после перезагрузки хоста
docker run NAME --rm #удаление контейнера после остановки
docker network create BRIDGE_NAME
docker network ls
```


 


