node['dokku']['plugins'].each do |plugin_name, repo_url|
  git "#{node['dokku']['plugins_dir']}/#{plugin_name}" do
    repository repo_url
    action :sync
  end
end

bash "dokku_plugins_install" do
  cwd node['dokku']['plugins_dir']
  code <<-EOH
    dokku plugins-install
  EOH
  only_if { node['dokku']['sync']['plugins'] }
end
