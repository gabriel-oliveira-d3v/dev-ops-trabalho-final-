# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky9"

  config.vm.define "control-node" do |c|
    c.vm.hostname = "control-node"
    c.vm.network "private_network", ip: "192.168.1.2"
    c.vm.provision "shell", path: "control-node/provision.sh"
    c.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end
  end

  config.vm.define "app01" do |a|
    a.vm.hostname = "app01"
    a.vm.network "forwarded_port", guest: 80, host: 8080
    a.vm.network "private_network", ip: "192.168.1.3"
    a.vm.provision "shell", path: "app01/provision.sh"
    a.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 1024
      libvirt.cpus = 2
    end
  end

  config.vm.define "db01" do |d|
    d.vm.hostname = "db01"
    d.vm.network "forwarded_port", guest: 3306, host: 3306
    d.vm.network "private_network", ip: "192.168.1.4"
    d.vm.provision "shell", path: "db01/provision.sh"
    d.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 1024
      libvirt.cpus = 2
    end
  end
end
