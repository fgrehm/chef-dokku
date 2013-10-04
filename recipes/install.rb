# Bootstrap dokku
git "#{Chef::Config[:file_cache_path]}/dokku" do
  repository node['dokku']['git_repository']
  reference node['dokku']['git_revision']
  action :sync
end

bash "install_dokku" do
  cwd "#{Chef::Config[:file_cache_path]}/dokku"
  code <<-EOH
    make install
  EOH
  only_if { node['dokku']['sync']['base'] }
end
