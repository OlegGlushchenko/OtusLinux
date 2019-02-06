# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
	config.vm.box = "hashicorp-vagrant/centos-7.4"
	config.vm.define "centosl6" do |centos|
		centos.vm.hostname = "centosl6"
		config.vm.box_check_update = false
		config.vm.provider "virtualbox" do |vb|
			vb.gui = false
			vb.memory = "256"
			vb.name = "centosl6"
		end
end
end
