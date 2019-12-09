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

## **Выполнено:**

1. Создан  свой кастомный образ nginx на базе alpine. 

- Для создания образа подготовлен следующий [Dockerfile](Dockerfile).


docker build -t my-nginx-image:latest .
docker images
docker login
docker push stump773/my-nginx-image
docker images
docker rmi
docker run -d -p 80:80 stump773/my-nginx-image
docker ps
curl localhost


https://docs.docker.com/glossary/
Образ

Docker images are the basis of containers. 
An Image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime. 
An image typically contains a union of layered filesystems stacked on top of each other. An image does not have state and it never changes.

Образ докера являются основой контейнеров. Образ - это упорядоченная коллекция изменений корневой файловой системы и соответствующих параметров 
выполнения для использования в среде выполнения контейнера. 
Образ обычно содержит объединение многоуровневых файловых систем, расположенных друг на друге. Образ не имеет состояния и никогда не изменяется.


Контейнер 
A container is a runtime instance of a docker image.

A Docker container consists of

A Docker image
An execution environment
A standard set of instructions
The concept is borrowed from Shipping Containers, which define a standard to ship goods globally. Docker defines a standard to ship software.


Контейнер-это исполняемый экземпляр образа docker.
Контейнер Docker состоит из
Docker образа 
Среды выполнения
Стандартного набора инструкций
Концепция заимствована из морских контейнеров, которые определяют стандарт для доставки товаров по всему миру. 
Docker определяет стандарт для отправки программного обеспечения.





Возможно
https://github.com/moul/docker-kernel-builder
