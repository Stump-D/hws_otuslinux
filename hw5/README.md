# **Домашнее задание №5: Инициализация системы. Systemd и SysV**

## **Задание:**
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

4*. Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл
Задание необходимо сделать с использованием Vagrantfile и proviosioner shell (или ansible, на Ваше усмотрение)

## **Выполнено: (для проверки достаточно использовать [Vagrantfile](Vagrantfile))**

1. Создание сервиса, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig

    1. Создаем конфигурационнй файл [/etc/sysconfig/watchlog](watchlog)
    2. Cоздаем тестовый /var/log/watchlog.log
    ```bash
    echo `date` > /var/log/watchlog.log
    echo 'ALERT' >> /var/log/watchlog.log
    ```
    3. Создаем скрипт [/opt/watchlog.sh](watchlog.sh)
    4. Создаем юнит для сервис [/etc/systemd/system/watchlog.service](watchlog.service)
    5. Создаем юнить для таймера [/etc/systemd/system/watchlog.timer](watchlog.timer)
    6. Разрешаем запуск таймера 
    ```
    systemctl enable watchlog.timer
    ```
    7. Запускаем таймер.
    ```
    systemctl start watchlog.timer
    ```
    8. Стартуем для начала отчета сам сервис.
    ```
    systemctl start watchlog.service
    ```
    9. Проверяем работу сервиса в syslog.
    ```
    sudo tail -f /var/log/messages
    ```

    Соответствующая секция в Vagrant shell provisioner выглядит следующим образом:

    ```bash
    #########################################
    #1.watchlog service & timer installation#
    #########################################
    wget https://raw.githubusercontent.com/Stump-D/hws_otuslinux/master/hw5/watchlog -O /etc/sysconfig/watchlog

    echo `date` > /var/log/watchlog.log
    echo 'ALERT' >> /var/log/watchlog.log

    wget https://raw.githubusercontent.com/Stump-D/hws_otuslinux/master/hw5/watchlog.sh -O /opt/watchlog.sh
    chmod +x /opt/watchlog.sh
    wget https://raw.githubusercontent.com/Stump-D/hws_otuslinux/master/hw5/watchlog.service -O /etc/systemd/system/watchlog.service
    wget https://raw.githubusercontent.com/Stump-D/hws_otuslinux/master/hw5/watchlog.timer -O /etc/systemd/system/watchlog.timer

    systemctl enable watchlog.timer
    systemctl start watchlog.timer
    systemctl start watchlog.service
    ```

2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
    1. Устанавливаем spawn-fcgi и необходимые для него пакеты:
    ```
    yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
    ```
    2. Правим /etc/sysconfig/spawn-fcgi
    ```
    cat /etc/sysconfig/spawn-fcgi
    # You must set some working options before the "spawn-fcgi" service will work.
    # If SOCKET points to a file, then this file is cleaned up by the init script.
    #
    # See spawn-fcgi(1) for all possible options.
    #
    # Example :
    SOCKET=/var/run/php-fcgi.sock
    OPTIONS="-u apache -g apache -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cg
    ```
    3. Создаем /etc/systemd/system/spawn-fcgi.service
    ```
    [Unit]
    Description=Spawn-fcgi startup service by Otus
    After=network.target
    [Service]
    Type=simple
    PIDFile=/var/run/spawn-fcgi.pid
    EnvironmentFile=/etc/sysconfig/spawn-fcgi
    ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
    KillMode=process
    [Install]
    WantedBy=multi-user.target
    ```
    4. Убеждаемся что все успешно работает:
    ```
    systemctl start spawn-fcgi
    sudo systemctl status spawn-fcgi
    ```
    
    Соответствующая секция в Vagrant shell provisioner выглядит следующим образом:
    ```
    ####################################
    #2. spawn-fcgi service installation#
    ####################################
    yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
    if [ -w /etc/sysconfig/spawn-fcgi ]; then sed -i '7,8 s/#//g' /etc/sysconfig/spawn-fcgi;fi
    wget https://raw.githubusercontent.com/Stump-D/hws_otuslinux/master/hw5/spawn-fcgi.service -O /etc/systemd/system/spawn-fcgi.service
    systemctl start spawn-fcgi
    ```
                                                                                         
    
    

```bash
sudo tail -f /var/log/messages
sudo systemctl status spawn-fcgi
sudo ss -tnulp | grep httpd
```
