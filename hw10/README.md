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

<<<<<<< HEAD
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
=======
python -V
sudo yum install ansible -y
ansible --version
mkdir Ansible
cd Ansible
wget https://gist.githubusercontent.com/lalbrekht/f811ce9a921570b1d95e07a7dbebeb1e/raw/9d6f9e1ad06b257c3dc6d80a045baa6c5b75dd88/gistfile1.txt -O Vagrantfile
vagrant ssh-config
>>>>>>> parent of 223d8dc... Домашнее задание №10: Первые шаги с Ansible
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
<<<<<<< HEAD
```

Создаем [ansible.cfg](./Ansible/ansible.cfg), [inventory](./Ansible/hosts.yml) файлы

Проверим, что Ansible может управлять нашим хостом
                   
```
[root@4otus Ansible]# ansible nginxhost -m ping
nginxhost | SUCCESS => {
=======
                   
[root@4otus Ansible]# ansible nginx -i staging/hosts -m ping
nginx | SUCCESS => {
>>>>>>> parent of 223d8dc... Домашнее задание №10: Первые шаги с Ansible
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
<<<<<<< HEAD
```
 
Создаем:
- Playbook  [nginx-playbook.yml](./Ansible/nginx-playbook.yml),
- Шаблон [nginx.conf.j2](./Ansible/templates/nginx.conf.j2) 
- Шаблон [index.html.j2](./Ansible/templates/index.html.j2)


Запускаем
```
[root@4otus Ansible]# ansible-playbook -i hosts.yml nginx-playbook.yml
```

Проверяем
```
[root@4otus Ansible]# curl http://192.168.11.150:8080
# Ansible managed
<h1> Welcome to nginxhost </h1>
```

Задание со (*)

Запускаем:
```
[root@4otus Ansible]# ansible-playbook playbooks/nginx.yml
```

PLAY [NGINX | Install and configure NGINX] **********************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************
ok: [nginxhost]

<<<<<<< HEAD
TASK [NGINX | Install EPEL Repo package] ************************************************************************************************************
ok: [nginxhost]

TASK [NGINX | Install NGINX package from EPEL Repo] *************************************************************************************************
ok: [nginxhost]

TASK [Configure html file | Config html file from template] *****************************************************************************************
ok: [nginxhost]

TASK [NGINX | Create NGINX config file from template] ***********************************************************************************************
=======
TASK [nginx : NGINX | Install EPEL Repo package] ****************************************************************************************************
ok: [nginxhost]

TASK [nginx : NGINX | Install NGINX package from EPEL Repo] *****************************************************************************************
ok: [nginxhost]

TASK [nginx : Configure html file | Config html file from template] *********************************************************************************
ok: [nginxhost]

TASK [nginx : NGINX | Create NGINX config file from template] ***************************************************************************************
>>>>>>> hw15
ok: [nginxhost]

PLAY RECAP ******************************************************************************************************************************************
nginxhost                  : ok=5    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

Проверяем:
```
[root@4otus hw10]# curl http://192.168.11.150:8080
# Ansible managed
<h1> Welcome to nginxhost </h1>
```
=======
                   
[root@4otus Ansible]# ansible nginx -m ping
nginx | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
 
[root@4otus Ansible]#  ansible nginx -m command -a "uname -r"
nginx | CHANGED | rc=0 >>
3.10.0-957.12.2.el7.x86_64

[root@4otus Ansible]# ansible nginx -m systemd -a name=firewalld
nginx | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "name": "firewalld",
    "status": {
        "ActiveEnterTimestampMonotonic": "0",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "inactive",


[root@4otus Ansible]# ansible nginx -m yum -a "name=epel-release state=present" -b
nginx | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "changes": {
        "installed": [
            "epel-release"
        ]

[root@4otus Ansible]# ansible-playbook epel.yml

PLAY [Install EPEL Repo] ************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [nginx]

TASK [Install EPEL Repo package from standart repo] *********************************************************************************************************
ok: [nginx]

PLAY RECAP **************************************************************************************************************************************************
nginx                      : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


[root@4otus Ansible]#  ansible nginx -m yum -a "name=epel-release state=absent" -b
^Xnginx | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": true,
    "changes": {
        "removed": [
            "epel-release"
 

[root@4otus Ansible]# ansible-playbook epel.yml

PLAY [Install EPEL Repo] ************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [nginx]

TASK [Install EPEL Repo package from standart repo] *********************************************************************************************************
changed: [nginx]

PLAY RECAP **************************************************************************************************************************************************
nginx                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


[root@4otus Ansible]# ansible-playbook nginx.yml --list-tags

playbook: nginx.yml

  play #1 (nginx): NGINX | Install and configure NGINX  TAGS: []
      TASK TAGS: [epel-package, nginx-package, packages]


[root@4otus Ansible]# ansible-playbook nginx.yml -t nginx-package

PLAY [NGINX | Install and configure NGINX] ******************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************
ok: [nginx]

TASK [NGINX | Install NGINX package from EPEL Repo] *********************************************************************************************************
changed: [nginx]

PLAY RECAP **************************************************************************************************************************************************
nginx                      : ok=2    changed=1    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0


>>>>>>> parent of 223d8dc... Домашнее задание №10: Первые шаги с Ansible

