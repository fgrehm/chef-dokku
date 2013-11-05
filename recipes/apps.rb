node['dokku']['apps'].each do |app_name, config|
  delete = !!config['remove']
  directory "/home/dokku/#{app_name}" do
    owner 'dokku'
    group 'dokku'
    action delete ? :delete : :create
  end

  template "/home/dokku/#{app_name}/ENV" do
    source 'apps/ENV.erb'
    owner  'dokku'
    group  'dokku'
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
