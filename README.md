# Trabalho de Fundamentos de DevOps

Ambiente de laboratório criado com Vagrant, Ansible, SonarQube e Jenkins.

## Maquinas

| VM | IP | Funcao |
|----|----|--------|
| control-node | 192.168.1.2 | Ansible Control Node |
| app01 | 192.168.1.3 | Servidor de aplicacao (httpd) |
| db01 | 192.168.1.4 | Servidor de banco de dados (mariadb) |
| sonarqube | 192.168.1.5 | Analise estatica de codigo |
| jenkins | 192.168.1.6 | Pipeline CI/CD |

## Como usar

```bash
vagrant up
vagrant status
```

Teste do Ansible:

```bash
vagrant ssh control-node
cd /home/vagrant/ansible
ansible all -m ping
ansible-playbook playbooks/site.yml
```

Acessos:

- Apache: http://localhost:8080
- SonarQube: http://localhost:9000
- Jenkins: http://localhost:8081

## Estrutura

```
.
├── Vagrantfile
├── ansible/
│   ├── ansible.cfg
│   ├── inventory.ini
│   └── playbooks/
├── app01/
├── control-node/
├── db01/
├── jenkins/
├── sonarqube/
├── app-exemplo/
└── Jenkinsfile
```
