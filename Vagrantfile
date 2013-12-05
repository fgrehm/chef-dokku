# -*- mode: ruby -*-
# vi: set ft=ruby :
# NOTE: Before running `vagrant up`, install the following plugins:
# vagrant plugin install vagrant-cachier
# vagrant plugin install vagrant-omnibus

# Test domain, change as needed
DOKKU_DOMAIN = ENV['DOKKU_DOMAIN'] || 'dokku.me'
# Ideally, we should use vagrant-auto_network and vagrant-hostmanager or
# vagrant-hostupdater to automatically assign a private IP and create a
# /etc/hosts entry for that IP. However, there is a bug in auto_network
# that is preventing this:
# https://github.com/adrienthebo/vagrant-auto_network/issues/2
DOKKU_IP = ENV['DOKKU_IP'] || '10.0.0.2'

Vagrant.configure('2') do |config|
  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.box = 'raring64'
  config.vm.network :private_network, ip: DOKKU_IP

  config.vm.provider :virtualbox do |vb, overrides|
    overrides.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box'
    vb.customize [ "modifyvm", :id, "--memory", 1536, "--cpus", "2" ]
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    # Ubuntu's Raring 64-bit cloud image is set to a 32-bit Ubuntu OS type by
    # default in Virtualbox and thus will not boot. Manually override that.
    vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
  end

  # Install htop before configuring dokku so that we can SSH into the VM to
  # keep an eye on things while they are being configured
  config.vm.provision :shell, inline: 'sudo apt-get install -y htop'

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['vendor/cookbooks']
    chef.add_recipe "dokku::bootstrap"
    chef.json = {
      dokku: {
        domain: DOKKU_DOMAIN,
        plugins: {
          postgresql: 'https://github.com/Kloadut/dokku-pg-plugin.git'
        },
        apps: {
          hello: {
            env: { 'NAME' => 'vagrant' }
          }
        },
        ssh_keys: {
          vagrant: 'ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ== vagrant insecure public key'
        }
      }
    }
  end
end
