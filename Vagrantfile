# -*- mode: ruby -*-
# vi: set ft=ruby :

# Test domain, change as needed
DOKKU_DOMAIN = 'dokku.vagrant'

# In case you have the stack available
PREBUILT_STACK_URL = File.exist?("#{Dir.pwd}/tmp/stack.tgz") ?
  'file:///vagrant/tmp/stack.tgz' :
  'https://s3.amazonaws.com/progrium-dokku/progrium_buildstep_79cf6805cf.tgz'

Vagrant.configure("2") do |config|
  config.vm.box = "raring64"

  config.cache.auto_detect = true
  config.omnibus.chef_version = :latest

  config.vm.provider :virtualbox do |_, overrides|
    overrides.vm.box_url = 'http://goo.gl/Y4aRr'
  end

  config.vm.provider :lxc do |lxc, overrides|
    # Required to boot nested containers
    lxc.customize 'aa_profile', 'unconfined'
    overrides.vm.box_url = "http://bit.ly/vagrant-lxc-raring64-2013-07-12"
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = ['vendor/cookbooks']
    chef.add_recipe "lxc"
    chef.add_recipe "dokku::bootstrap"
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
