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
    action :create
    variables(
      "env" => config['env'] || {}
    )
    not_if { delete }
  end

  # Clean up docker
  if delete
    docker_container "app/#{app_name}" do
      action :remove
    end

    docker_image "app/#{app_name}" do
      action :remove
    end
  end
end
