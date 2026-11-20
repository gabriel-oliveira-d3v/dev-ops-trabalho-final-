#!/usr/bin/env bash

echo "=========================="
echo "Instalacao de dependencias"
echo "=========================="
sudo dnf install -y podman wget curl git vim unzip

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
echo "Volume e container do Jenkins"
echo "=========================="
sudo podman volume create jenkins_home || true
sudo podman run -d --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -u root \
  docker.io/jenkins/jenkins:latest

echo "=========================="
echo "Status do container"
echo "=========================="
sudo podman ps
