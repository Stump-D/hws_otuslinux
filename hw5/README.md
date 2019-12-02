# **Домашнее задание №5: Инициализация системы. Systemd и SysV**

## **Задание:**
1. Написать сервис, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова. Файл и слово должны задаваться в /etc/sysconfig
2. Из epel установить spawn-fcgi и переписать init-скрипт на unit-файл. Имя сервиса должно так же называться.
3. Дополнить юнит-файл apache httpd возможностьб запустить несколько инстансов сервера с разными конфигами

4*. Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл
Задание необходимо сделать с использованием Vagrantfile и proviosioner shell (или ansible, на Ваше усмотрение)

## **Выполнено:**


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

```bash
sudo tail -f /var/log/messages
sudo systemctl status spawn-fcgi
sudo ss -tnulp | grep httpd
```
