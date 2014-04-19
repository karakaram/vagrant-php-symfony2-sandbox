VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  # http://nrel.github.io/vagrant-boxes/
  config.vm.box = "CentOS-6.5-v20140311"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.5-x86_64-v20140311.box"

  config.vm.network :private_network, ip: "192.168.33.10"

  config.vm.synced_folder "~/vagrant_symfony2_sync", "/var/www/vagrant", :create => true, :owner=> 'vagrant', :group=>'vagrant', :mount_options => ['dmode=775,fmode=664']
  # config.vm.synced_folder "~/vagrant_symfony2_sync", "/var/www/vagrant", :create => true, type: "nfs"

  # config.omnibus.chef_version = "11.4.0"

  config.vm.provider :virtualbox do |vb|
    # vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "4"]
    # vb.customize ["modifyvm", :id, "--ioapic", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "base"
    chef.add_recipe "mysql56"
    chef.add_recipe "nginx"
    chef.add_recipe "php55"
    chef.add_recipe "symfony"
    chef.add_recipe "samba"
    chef.json = {
      nginx: {
        port: 80,
        document_root: "/var/www/vagrant"
      },
      php: {
        remote_host: "192.168.33.1",
        xdebug_enable: 0,
        xdebug_idekey: "PHPSTORM"
      },
      samba: {
        enable: 0,
        hosts_allow: '192.168.33.0/24'
      }
    }
  end
end
# -*- mode: ruby -*-
# vi: set ft=ruby :
