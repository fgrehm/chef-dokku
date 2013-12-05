require 'spec_helper'

describe 'dokku::plugins' do
  let(:chef_runner) do 
    ChefSpec::Runner.new do |node|
      node.set['dokku']['plugins'] = {
        'config' => 'https://github.com/josegonzalez/dokku-config.git' 
      }
    end
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  context 'installing plugins' do
    it 'should clone the plugins' do
      expect(chef_run).to sync_git("/var/lib/dokku/plugins/config")
    end
  end

  it 'should delete the nginx-vhosts install hook' do
    expect(chef_run).to delete_file '/var/lib/dokku/plugins/nginx-vhosts/install'
  end

  it 'should add dokku to the sudoers group' do
    expect(chef_run).to install_sudo('dokku-nginx-reload').with(
      'user' => '%dokku',
      'commands' => ['/etc/init.d/nginx reload'],
      'nopasswd' => true
    )
  end

  it 'should create /etc/nginx/conf.d/dokku.conf if missing' do
    expect(chef_run).to create_template_if_missing("/etc/nginx/conf.d/dokku.conf").with(
      source: 'plugins/nginx-vhosts/dokku.conf',
      user: 'root',
      group: 'root'
    )
  end

  it 'should use the dokku.conf template for /etc/nginx/conf.d/dokku.conf' do
    file = chef_run.template("/etc/nginx/conf.d/dokku.conf")
    expect(file.owner).to eq('root')
    expect(file.group).to eq('root')
  end

  it 'should run dokku_plugins_install' do
    expect(chef_run).to run_bash("dokku_plugins_install").with(
      :cwd => '/var/lib/dokku/plugins'
    )
  end
  
end
