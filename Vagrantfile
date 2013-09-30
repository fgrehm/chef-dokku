# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "raring64"

  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |_, overrides|
    overrides.vm.box_url = 'http://goo.gl/Y4aRr'
  end

  config.vm.provider :lxc do |lxc, overrides|
    # Required to boot nested containers
    lxc.customize 'aa_profile', 'unconfined'
    overrides.vm.box_url = "http://bit.ly/vagrant-lxc-raring64-2013-07-12"
  end

  config.vm.provision :shell, inline: %[
    # Required to boot nested containers
    if ! [ -f /etc/default/lxc ]; then
      cat <<STR > /etc/default/lxc
LXC_AUTO="false"
USE_LXC_BRIDGE="false"
STR
    fi

    # This is a HACK!
    if ! [ -L /tmp/vagrant-chef-1/cookbooks/cookbooks/dokku ]; then
      mkdir -p /tmp/vagrant-chef-1/cookbooks/cookbooks
      ln -s /vagrant /tmp/vagrant-chef-1/cookbooks/cookbooks/dokku
    fi
  ]

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "dokku"
    chef.json = {
      dokku: {
        domain: 'vagrant.local',
        plugins: {
          postgresql: 'https://github.com/Kloadut/dokku-pg-plugin.git'
        },
        apps: {
          'hello' => {
            env: { 'NAME' => 'vagrant' }
          }
        }
      }
    }
  end
end
