require 'spec_helper'

describe 'dokku::plugins' do
  let(:chef_runner) do 
    runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
    runner
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  #TODO: write specs for the git clones
  #Need ChefSpec v3 to do that

  it 'should delete the nginx-vhosts install hook' do
    expect(chef_run).to delete_file '/var/lib/dokku/plugins/nginx-vhosts/install'
  end

  # Doesn't work
  #it 'should create /etc/init/nginx-reloader.conf if missing' do
    #expect(chef_run).to create_if_missing_file "/etc/init/nginx-reloader.conf"
  #end

  it 'should use the nginx-reloader.conf template for /etc/init/nginx-reloader.conf' do
    file = chef_run.template("/etc/init/nginx-reloader.conf")
    expect(file).to be_owned_by('root', 'root')
  end

  # Doesn't work
  #it 'should create /etc/nginx/conf.d/dokku.conf if missing' do
    #expect(chef_run).to create_if_missing_file "/etc/nginx/conf.d/dokku.conf"
  #end

  it 'should use the dokku.conf template for /etc/nginx/conf.d/dokku.conf' do
    file = chef_run.template("/etc/nginx/conf.d/dokku.conf")
    expect(file).to be_owned_by('root', 'root')
  end

  it 'should start the nginx-reloader service' do
    expect(chef_run).to start_service 'nginx-reloader'
  end

  it 'should run dokku_plugins_install' do
    expect(chef_run).to execute_bash_script('dokku_plugins_install').with(
      :cwd => '/var/lib/dokku/plugins'
    )
  end
  
end
