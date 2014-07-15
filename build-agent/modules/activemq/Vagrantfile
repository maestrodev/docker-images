# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos-65-x64-virtualbox-puppet"
  config.vm.network :forwarded_port, guest: 8161, host: 19000
  config.vm.network :forwarded_port, guest: 61613, host: 19001

  config.vm.synced_folder ".", "/etc/puppet/modules/activemq"
  config.vm.synced_folder "spec/fixtures/modules/wget", "/etc/puppet/modules/wget"

  # install the java and epel modules
  config.vm.provision :shell, :inline => "test -d /etc/puppet/modules/java || puppet module install puppetlabs/java -v 1.1.0"
  config.vm.provision :shell, :inline => "test -d /etc/puppet/modules/epel || puppet module install stahnma/epel -v 0.0.6"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "spec/manifests"
    puppet.manifest_file  = "site.pp"
  end
end
