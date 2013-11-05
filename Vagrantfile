# -*- mode: ruby -*-
# vi: set ft=ruby :
# NOTE: Before running `vagrant up`, install the following plugins:
# vagrant plugin install vagrant-berkshelf
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
# In case you have the stack available
PREBUILT_STACK_URL = File.exist?("#{Dir.pwd}/tmp/stack.tgz") ?
  'file:///vagrant/tmp/stack.tgz' :
  'https://s3.amazonaws.com/progrium-dokku/progrium_buildstep_c30652f59a.tgz'

Vagrant.configure('2') do |config|
  # Enable plugins
  # Berkshelf plugin disabled since slow and broken for vagrant-lxc. See #6.
  #config.berkshelf.enabled = true
  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.box = 'raring64'
  config.vm.network :private_network, ip: DOKKU_IP

  config.vm.provider :virtualbox do |vb, overrides|
    overrides.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box'
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
    # Ubuntu's Raring 64-bit cloud image is set to a 32-bit Ubuntu OS type by
    # default in Virtualbox and thus will not boot. Manually override that.
    vb.customize ['modifyvm', :id, '--ostype', 'Ubuntu_64']
  end

  config.vm.provider :lxc do |lxc, overrides|
    # Required to boot nested containers
    lxc.customize 'aa_profile', 'unconfined'
    overrides.vm.box_url = 'http://bit.ly/vagrant-lxc-raring64-2013-07-12'

    overrides.vm.provision :chef_solo do |chef|
      chef.add_recipe 'lxc'
    end
  end

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe 'dokku::bootstrap'
    chef.json = {
      # Required to boot nested containers
      lxc: {
        auto_start: false,
        use_bridge: false
      },
      dokku: {
        domain: DOKKU_DOMAIN,
        buildstack: {
          prebuilt_url: PREBUILT_STACK_URL,
        },
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
