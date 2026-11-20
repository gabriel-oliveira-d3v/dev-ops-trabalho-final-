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
KEY_PRIV=""
KEY_PUB=""
for base in /vagrant /vagrant/control-node; do
  if [ -f "$base/lab_key" ]; then
    KEY_PRIV="$base/lab_key"
    KEY_PUB="$base/lab_key.pub"
    break
  fi
done
if [ -n "$KEY_PRIV" ]; then
  install -m 600 -o vagrant -g vagrant "$KEY_PRIV" /home/vagrant/.ssh/id_ed25519
  install -m 644 -o vagrant -g vagrant "$KEY_PUB" /home/vagrant/.ssh/id_ed25519.pub
  # Permite que o control-node conecte em si mesmo via Ansible
  grep -qF "$(cat "$KEY_PUB")" /home/vagrant/.ssh/authorized_keys 2>/dev/null || cat "$KEY_PUB" >> /home/vagrant/.ssh/authorized_keys
  chmod 600 /home/vagrant/.ssh/authorized_keys
  chown vagrant:vagrant /home/vagrant/.ssh/authorized_keys
else
  echo "ERRO: lab_key nao encontrada na pasta compartilhada"
fi

# Copia os playbooks do projeto (quando disponiveis na pasta compartilhada)
if [ -d /vagrant/ansible/playbooks ]; then
  mkdir -p /home/vagrant/ansible
  cp -r /vagrant/ansible/playbooks /home/vagrant/ansible/
  cp /vagrant/ansible/inventory.ini /home/vagrant/ansible/inventory.ini
  cp /vagrant/ansible/ansible.cfg /home/vagrant/ansible/ansible.cfg
  chown -R vagrant:vagrant /home/vagrant/ansible
fi

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
cat > /home/vagrant/ansible/ansible.cfg <<'CFG'
[defaults]
inventory = ./inventory.ini
host_key_checking = False
CFG
chown -R vagrant:vagrant /home/vagrant/ansible


echo "=== Correcao do SSH (reinstala openssh-server e reinicia sshd) ==="
sudo dnf install -y openssh-server
sudo systemctl enable sshd
sudo systemctl restart sshd
sudo systemctl status sshd --no-pager | head -10

grep -E 'control-node|app01|db01' /etc/hosts
python3 --version
ansible --version
