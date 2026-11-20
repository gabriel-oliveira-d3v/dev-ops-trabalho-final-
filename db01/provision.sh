#!/usr/bin/env bash

echo "=========================="
echo "atualizacao do S.O"
echo "=========================="
sudo dnf update -y

echo "=========================="
echo "Instalacao de dependencias"
echo "=========================="
sudo dnf install -y \
vim \
wget \
curl \
net-tools \
python3 \
git \
unzip

echo "=========================="
echo "Remove duplicacoes de hosts"
echo "=========================="
sudo sed -i '/192.168.1.2 control-node/d' /etc/hosts
sudo sed -i '/192.168.1.3 app01/d' /etc/hosts
sudo sed -i '/192.168.1.4 db01/d' /etc/hosts
sudo sed -i '/127\.0\.1\.1.*db01/d' /etc/hosts

echo "=========================="
echo "Adicionar os hosts"
echo "=========================="
sudo tee -a /etc/hosts > /dev/null <<EOT
192.168.1.2 control-node
192.168.1.3 app01
192.168.1.4 db01
EOT

echo "configuracao de chave publica (distribuida via pasta compartilhada /vagrant)"
PUB=""
for base in /vagrant /vagrant/db01; do
  if [ -f "$base/lab_key.pub" ]; then
    PUB="$base/lab_key.pub"
    break
  fi
done
if [ -n "$PUB" ]; then
  mkdir -p /home/vagrant/.ssh
  grep -qF "$(cat "$PUB")" /home/vagrant/.ssh/authorized_keys 2>/dev/null || cat "$PUB" >> /home/vagrant/.ssh/authorized_keys
  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown -R vagrant:vagrant /home/vagrant/.ssh
else
  echo "ERRO: lab_key.pub nao encontrada na pasta compartilhada"
fi

echo "=========================="
echo "Testes de conectividade"
echo "=========================="


echo "=== Correcao do SSH (reinstala openssh-server e reinicia sshd) ==="
sudo dnf install -y openssh-server
sudo systemctl enable sshd
sudo systemctl restart sshd
sudo systemctl status sshd --no-pager | head -10

grep -E 'control-node|app01|db01' /etc/hosts
echo "=========================="
echo "Versao Python"
echo "=========================="
python3 --version
