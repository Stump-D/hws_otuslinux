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
                                                                                         
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами
    1.Для запуска нескольких экземпляров сервиса будем использовать шаблон httpd@ в конфигурации файла окружений:
    ```
    cat /etc/systemd/system/httpd@.service
    [Unit]
    Description=The Apache HTTP Server
    After=network.target remote-fs.target nss-lookup.target
    Documentation=man:httpd(8)
    Documentation=man:apachectl(8)
    [Service]
    Type=notify
    EnvironmentFile=/etc/sysconfig/httpd-%I #добавим параметр %I сюда
    ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
    ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
    ExecStop=/bin/kill -WINCH ${MAINPID}
    KillSignal=SIGCONT
    PrivateTmp=true
    [Install]
    WantedBy=multi-user.target
    ```
    2. Создаем два файла окружения в /etc/sysconfig:
    ```
    # /etc/sysconfig/httpd-first
    OPTIONS=-f conf/first.conf
    # /etc/sysconfig/httpd-second
    OPTIONS=-f conf/second.conf
    ```
    3. Создаем два файла конфигурации в /etc/httpd/conf:
    ```
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
    ```
    4. Правим второй файл конфигурации second.conf для исключения пересечения по портам и PidFiles.
    ```
    PidFile /var/run/httpd-second.pid
    Listen 8080
    ```
    5. Запускаем и проверяем:
    ```
    systemctl start httpd@first
    systemctl start httpd@second
    systemctl status httpd@first
    systemctl status httpd@second
    sudo ss -tnulp | grep httpd
    ```
                  
    Соответствующая секция в Vagrant shell provisioner выглядит следующим образом:
    ```
    ######################################
    #3. double httpd service installation#
    ######################################
    cp /usr/lib/systemd/system/httpd.service /etc/systemd/system/httpd@.service
    sed -i 's!EnvironmentFile=/etc/sysconfig/httpd!EnvironmentFile=/etc/sysconfig/httpd-%I!' /etc/systemd/system/httpd@.service
    cp /etc/sysconfig/httpd /etc/sysconfig/httpd-first
    cp /etc/sysconfig/httpd /etc/sysconfig/httpd-second
    sed -i 's!#OPTIONS=!OPTIONS=-f conf/first.conf!' /etc/sysconfig/httpd-first
    sed -i 's!#OPTIONS=!OPTIONS=-f conf/second.conf!' /etc/sysconfig/httpd-second
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/first.conf
    cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/second.conf
    sed -i 's!Listen 80!Listen 8080!' /etc/httpd/conf/second.conf
    echo 'PidFile     /var/run/httpd/httpd-second.pid' >> /etc/httpd/conf/second.conf
    systemctl start httpd@first
    systemctl start httpd@second
    ```
                                                                                                                                                                                                         
