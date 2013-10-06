require 'spec_helper'

describe 'dokku::bootstrap' do
  let(:chef_runner) do 
    runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
    runner
  end

  let(:chef_run) { chef_runner.converge described_recipe }

  # Dependency recipes
  %w{apt git build-essential user nginx::repo nginx}.each do |recipe|
    it "includes the #{recipe} recipe" do
      expect(chef_run).to include_recipe recipe
    end
  end

  # Dependency packages
  %w{software-properties-common dnsutils}.each do |package|
    it "installs the #{package} package" do
      expect(chef_run).to install_package package
    end
  end

  # Dokku recipes
  %w{docker::aufs docker::package dokku::install dokku::plugins dokku::apps dokku::ssh_keys}.each do |recipe|
    it "includes the #{recipe} recipe" do
      expect(chef_run).to include_recipe recipe
    end
  end

  # gitreceive
  it "fetches gitreceive" do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/gitreceive").with(
      :source => 'https://raw.github.com/progrium/gitreceive/master/gitreceive'
    )
  end
  it "installs gitreceive" do
    expect(chef_run).to execute_bash_script('install_gitreceive').with(
      :cwd => Chef::Config[:file_cache_path]
    )
  end

  # sshcommand
  it "fetches sshcommand" do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/sshcommand").with(
      :source => 'https://raw.github.com/progrium/sshcommand/master/sshcommand'
    )
  end
  it "installs sshcommand" do
    expect(chef_run).to execute_bash_script('install_sshcommand').with(
      :cwd => Chef::Config[:file_cache_path]
    )
  end

  # pluginhook
  it "fetches pluginhook" do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/pluginhook_0.1.0_amd64.deb").with(
      :source => 'https://s3.amazonaws.com/progrium-pluginhook/pluginhook_0.1.0_amd64.deb',
      :checksum => '26a790070ee0c34fd4c53b24aabeb92778faed4004110c480c13b48608545fe5'
    )
  end
  # Doesn't work, need ChefSpec v3
  # https://github.com/acrmp/chefspec/blob/unify_matchers/lib/chefspec/api/dpkg_package.rb
  #it "installs pluginhook" do
    #expect(chef_run).to install_dpkg_package('pluginhook_0.1.0_amd64.deb')
  #end

  it "includes the nginx::repo recipe" do
    expect(chef_run).to include_recipe 'nginx::repo'
  end

  it 'should delete /etc/nginx/conf.d/default.conf' do
    expect(chef_run).to delete_file '/etc/nginx/conf.d/default.conf'
  end

  it 'should delete /etc/nginx/conf.d/example_ssl.conf' do
    expect(chef_run).to delete_file '/etc/nginx/conf.d/example_ssl.conf'
  end

  it "creates the docker group" do
    expect(chef_run).to create_group('docker')
    # with doesn't appear to chain properly off of create_group
    #expect(chef_run).to create_group('docker').with(
      #:members => ['git', 'dokku'], :append => true)
  end

  it "creates the VHOST file to the node's fqdn" do
    expect(chef_run).to create_file_with_content('/home/git/VHOST', chef_run.node['fqdn'])
  end

  context 'when the dokku domain is explicitly set' do
    let(:chef_runner) do
      runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
      runner.node.set['dokku']['domain'] = 'foobar.com'
      runner
    end

    it "creates the VHOST file with the content 'foobar.com'" do
      expect(chef_run).to create_file_with_content('/home/git/VHOST', 'foobar.com')
    end
  end
end
