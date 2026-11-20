#!/usr/bin/env bash
echo "atualizacao do cache de metadados (sem atualizar os pacotes do SO)"
sudo dnf makecache
echo "epel-release -> Extra packages for Enterprise Linux"
sudo dnf install -y epel-release git vim wget curl unzip net-tools python3
echo "Instalacao do ansible"
sudo dnf install -y ansible
echo "sed -> procurar, alterar em algum arquivo"
echo "-i -> editar"
echo "/d -> deletar"
sudo sed -i '/192.168.1.2 control-node/d' /etc/hosts
sudo sed -i '/192.168.1.3 app01/d' /etc/hosts
sudo sed -i '/192.168.1.4 db01/d' /etc/hosts
sudo sed -i '/127\.0\.1\.1.*control-node/d' /etc/hosts

sudo tee -a /etc/hosts > /dev/null <<EOT
192.168.1.2 control-node
192.168.1.3 app01
192.168.1.4 db01
EOT

echo "configuracao da chave privada SSH (recebida pela pasta compartilhada /vagrant)"
install -m 700 -o vagrant -g vagrant -d /home/vagrant/.ssh
install -m 600 -o vagrant -g vagrant /vagrant/lab_key /home/vagrant/.ssh/id_ed25519
install -m 644 -o vagrant -g vagrant /vagrant/lab_key.pub /home/vagrant/.ssh/id_ed25519.pub

echo "criacao do inventario do ansible"
mkdir -p /home/vagrant/ansible
cat > /home/vagrant/ansible/inventory.ini <<'INI'
[control]
control-node ansible_host=192.168.1.2

[servidores]
app01 ansible_host=192.168.1.3
db01 ansible_host=192.168.1.4

[servidores:vars]
ansible_user=vagrant
INI
chown -R vagrant:vagrant /home/vagrant/ansible


echo "=== Correcao do SSH (reinstala openssh-server e reinicia sshd) ==="
sudo dnf install -y openssh-server
sudo systemctl enable sshd
sudo systemctl restart sshd
sudo systemctl status sshd --no-pager | head -10

grep -E 'control-node|app01|db01' /etc/hosts
python3 --version
ansible --version
