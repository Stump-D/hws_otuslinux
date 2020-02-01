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

Создаем [inventory](./Ansible/host.yml) файл

Проверим, что Ansible может управлять нашим хостом
                   
```
[root@4otus Ansible]# ansible nginx -m ping
nginx | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python"
    },
    "changed": false,
    "ping": "pong"
}
```
 
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



