require 'spec_helper'

describe 'dokku::bootstrap' do
  let(:chef_runner) do 
    ChefSpec::Runner.new
  end

  let(:chef_run) { chef_runner.converge described_recipe }

  # We need to stub this modprobe call in the docker cookbook
  # since it causes Travis to fail
  # https://github.com/bflad/chef-docker/blob/587bf0334468eef4e1840231b566ff9e1fc8f1aa/recipes/aufs.rb#L33
  before do
    stub_command("modprobe -l | grep aufs").and_return(true)
  end

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

  # sshcommand
  it "fetches sshcommand" do
    expect(chef_run).to create_remote_file("#{Chef::Config[:file_cache_path]}/sshcommand").with(
      :source => 'https://raw.github.com/progrium/sshcommand/master/sshcommand'
    )
  end
  it "installs sshcommand" do
    expect(chef_run).to run_bash("install_sshcommand").with(
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

  it "installs pluginhook" do
    expect(chef_run).to install_dpkg_package('pluginhook_0.1.0_amd64.deb')
  end

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
    expect(chef_run).to create_group('docker').with(
      :members => ['dokku'], :append => true)
  end

  it "creates the VHOST file to the node's fqdn" do
    expect(chef_run).to render_file("/home/dokku/VHOST").with_content(chef_run.node['fqdn'])
  end

  context 'when the dokku domain is explicitly set' do
    let(:chef_runner) do
      ChefSpec::Runner.new do |node|
        node.set['dokku']['domain'] = 'foobar.com'
      end
    end

    it "creates the VHOST file with the content 'foobar.com'" do
      expect(chef_run).to render_file("/home/dokku/VHOST").with_content("foobar.com")
    end
  end

  it "restarts nginx" do
    expect(chef_run).to reload_service('nginx')
  end
end
