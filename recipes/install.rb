# Bootstrap dokku
git "#{Chef::Config[:file_cache_path]}/dokku" do
  repository node['dokku']['git_repository']
  reference node['dokku']['git_revision']
  action node['dokku']['sync']['base'] ? :sync : :checkout
end

bash "copy_dokku_files" do
  cwd "#{Chef::Config[:file_cache_path]}/dokku"
  code <<-EOH
    make copyfiles
  EOH
end
