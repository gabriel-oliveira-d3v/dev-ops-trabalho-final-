#!/usr/bin/env bash

echo "=========================="
echo "Instalacao de dependencias"
echo "=========================="
sudo dnf install -y podman wget curl git vim unzip openssh-server

echo "=========================="
echo "Iniciando sshd"
echo "=========================="
sudo systemctl enable --now sshd
sudo systemctl start sshd

echo "=========================="
echo "Configuracao do Podman"
echo "=========================="
sudo systemctl enable --now podman

echo "=========================="
echo "Firewall - liberar porta 8080"
echo "=========================="
sudo firewall-cmd --permanent --add-port=8080/tcp || true
sudo firewall-cmd --permanent --add-port=50000/tcp || true
sudo firewall-cmd --reload || true

echo "=========================="
echo "Preparacao do init.groovy (volume bind para primeira inicializacao)"
echo "=========================="
sudo mkdir -p /var/jenkins_home/init.groovy.d
sudo cp /vagrant/jenkins/init.groovy /var/jenkins_home/init.groovy.d/init.groovy
sudo chmod 644 /var/jenkins_home/init.groovy.d/init.groovy
sudo chown -R 1000:1000 /var/jenkins_home

echo "=========================="
echo "Volume e container do Jenkins"
echo "=========================="
sudo podman volume create jenkins_home || true
sudo podman rm -f jenkins || true
sudo podman run -d --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/jenkins_home/init.groovy.d:/usr/share/jenkins/ref/init.groovy.d:Z \
  -u root \
  docker.io/jenkins/jenkins:latest

echo "=========================="
echo "Status do container"
echo "=========================="
sudo podman ps
