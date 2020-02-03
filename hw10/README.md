# **Домашнее задание №10: Первые шаги с Ansible**

## **Задание:**

Подготовить стенд на Vagrant как минимум с одним сервером. На этом сервере используя Ansible необходимо развернуть nginx со следующими условиями:
- необходимо использовать модуль yum/apt
- конфигурационные файлы должны быть взяты из шаблона jinja2 с перемененными
- после установки nginx должен быть в режиме enabled в systemd
- должен быть использован notify для старта nginx после установки
- сайт должен слушать на нестандартном порту - 8080, для этого использовать переменные в Ansible
* Сделать все это с использованием Ansible роли

Домашнее задание считается принятым, если:
- предоставлен Vagrantfile и готовый playbook/роль ( инструкция по запуску стенда, если посчитаете необходимым )
- после запуска стенда nginx доступен на порту 8080
- при написании playbook/роли соблюдены перечисленные в задании условия
Критерии оценки: Ставим 5 если создан playbook
Ставим 6 если написана роль

## **Выполнено:**


Установка Ansible
```
python -V
sudo yum install ansible -y
ansible --version
```

Подготовка окружения
```
mkdir Ansible
cd Ansible
wget https://gist.githubusercontent.com/lalbrekht/f811ce9a921570b1d95e07a7dbebeb1e/raw/9d6f9e1ad06b257c3dc6d80a045baa6c5b75dd88/gistfile1.txt -O Vagrantfile
```

Использован [Vagrantfile](./Ansible/Vagrantfile)

```
[root@4otus Ansible]vagrant ssh-config
Host nginx
HostName 127.0.0.1
User vagrant
Port 2222
UserKnownHostsFile /dev/null
StrictHostKeyChecking no
PasswordAuthentication no
IdentityFile /root/otuslinux/hws_otuslinux/hw10/Ansible/.vagrant/machines/nginx/virtualbox/private_key
IdentitiesOnly yes
LogLevel FATAL
```

Создаем [ansible.cfg](./Ansible/ansible.cfg), [inventory](./Ansible/hosts.yml) файлы

Проверим, что Ansible может управлять нашим хостом
                   
```
[root@4otus Ansible]# ansible nginxhost -m ping
nginxhost | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
 
Создаем:
- Playbook  [nginx-playbook.yml](./Ansible/nginx-playbook.yml),
- Шаблон [nginx.conf.j2](./Ansible/templates/nginx.conf.j2) 
- Шаблон [index.html.j2](./Ansible/templates/index.html.j2)


Запускаем
```
[root@4otus Ansible]# ansible-playbook -i hosts.yml nginx-playbook.yml

PLAY [NGINX | Install and configure NGINX] **********************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [nginxhost]

TASK [NGINX | Install EPEL Repo package] ************************************************************************************************************
ok: [nginxhost]

TASK [NGINX | Install NGINX package from EPEL Repo] *************************************************************************************************
ok: [nginxhost]

TASK [Configure html file | Config html file from template] *****************************************************************************************
ok: [nginxhost]

TASK [NGINX | Create NGINX config file from template] ***********************************************************************************************
ok: [nginxhost]

PLAY RECAP ******************************************************************************************************************************************
nginxhost                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Проверяем
```
[root@4otus Ansible]# curl http://192.168.11.150:8080
# Ansible managed
<h1> Welcome to nginxhost </h1>
```
