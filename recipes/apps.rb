node['dokku']['apps'].each do |app_name, config|
  delete = !!config['remove']
  directory "/home/git/#{app_name}" do
    owner 'git'
    group 'git'
    action delete ? :delete : :create
  end

  template "/home/git/#{app_name}/ENV" do
    source 'apps/ENV.erb'
    owner  'git'
    group  'git'
    action :create_if_missing
    variables(
      "env" => config['env'] || {}
    )
    not_if { delete }
  end
end
