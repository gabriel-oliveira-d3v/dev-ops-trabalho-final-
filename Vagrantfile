# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky9"
  config.vm.synced_folder ".", "/vagrant"

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

  config.vm.define "sonarqube" do |s|
    s.vm.hostname = "sonarqube"
    s.vm.network "forwarded_port", guest: 9000, host: 9000
    s.vm.network "private_network", ip: "192.168.1.5"
    s.vm.provision "shell", path: "sonarqube/provision.sh"
    s.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end
  end

  config.vm.define "jenkins" do |j|
    j.vm.hostname = "jenkins"
    j.vm.network "forwarded_port", guest: 8080, host: 8081
    j.vm.network "private_network", ip: "192.168.1.6"
    j.vm.provision "shell", path: "jenkins/provision.sh"
    j.vm.provider "libvirt" do |libvirt|
      libvirt.memory = 2048
      libvirt.cpus = 2
    end
  end
end
