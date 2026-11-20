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
echo "Ajuste do kernel para o SonarQube (Elasticsearch)"
echo "=========================="
echo "vm.max_map_count=524288" | sudo tee /etc/sysctl.d/99-sonarqube.conf
sudo sysctl --system

echo "=========================="
echo "Firewall - liberar porta 9000"
echo "=========================="
sudo firewall-cmd --permanent --add-port=9000/tcp || true
sudo firewall-cmd --reload || true

echo "=========================="
echo "Volumes e container do SonarQube"
echo "=========================="
sudo podman volume create sonarqube_data || true
sudo podman volume create sonarqube_extensions || true
sudo podman run -d --name sonarqube \
  -p 9000:9000 \
  -v sonarqube_data:/opt/sonarqube/data \
  -v sonarqube_extensions:/opt/sonarqube/extensions \
  -e SONAR_ES_BOOTSTRAP_CHECKS_DISABLE=true \
  docker.io/library/sonarqube:community

echo "=========================="
echo "Status do container"
echo "=========================="
sudo podman ps
