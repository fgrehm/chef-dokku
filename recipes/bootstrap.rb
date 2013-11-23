# This is essentially a chef version of https://github.com/progrium/dokku/blob/master/bootstrap.sh
# We are doing it this way so we can allow chef to install/configure some of our dependencies
# instead of allowing the bootstrap script to do it

# Cookbook deps
%w{apt git build-essential user}.each do |dep|
  include_recipe dep
end

# Package deps
%w{software-properties-common dnsutils apt-transport-https}.each do |dep|
  package dep
end

# Install sshcommand
sshcommand_name = node['dokku']['sshcommand']['filename']
sshcommand_path = "#{Chef::Config[:file_cache_path]}/#{sshcommand_name}"

remote_file sshcommand_path do
  source node['dokku']['sshcommand']['src_url']
end

bash 'install_sshcommand' do
  cwd ::File.dirname(sshcommand_path)
  code <<-EOH
    cp sshcommand /usr/local/bin
    chmod +x /usr/local/bin/sshcommand
    sshcommand create dokku /usr/local/bin/dokku
  EOH
  only_if { node['dokku']['sync']['dependencies'] }
end

# Install pluginhook
pluginhook_name = node['dokku']['pluginhook']['filename']
pluginhook_path = "#{Chef::Config[:file_cache_path]}/#{pluginhook_name}"

remote_file pluginhook_path do
  source node['dokku']['pluginhook']['src_url']
  checksum node['dokku']['pluginhook']['checksum']
end

dpkg_package pluginhook_name do
  source pluginhook_path
  only_if { node['dokku']['sync']['dependencies'] }
end

# Pull in aufs
include_recipe "docker::aufs"

# Create docker group with dokku as member
group "docker" do
  append true
  members ['dokku']
end

# Install docker
include_recipe "docker::package"

# Buildstack
include_recipe "dokku::buildstack"

# Dokku install
include_recipe "dokku::install"

# Install nginx ahead of the plugin install so that it is
# chef managed
include_recipe 'nginx::repo'
include_recipe 'nginx'

# Clean up distribution configs
file '/etc/nginx/conf.d/example_ssl.conf' do
  action :delete
end

file '/etc/nginx/conf.d/default.conf' do
  action :delete
end

include_recipe 'dokku::plugins'
include_recipe 'dokku::apps'

#set VHOST
domain = node['dokku']['domain'] || node['fqdn']
file File.join(node['dokku']['root'], 'VHOST') do
  content domain
end

include_recipe "dokku::ssh_keys"

# Reload nginx
service 'nginx' do
  action :reload
end
