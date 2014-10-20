node['dokku']['apps'].each do |app_name, config|
  delete = !!config['remove']
  app_directory = File.join(node['dokku']['root'], app_name)
  directory app_directory do
    owner 'dokku'
    group 'dokku'
    action delete ? :delete : :create
  end

  template File.join(app_directory, 'ENV') do
    source 'apps/ENV.erb'
    owner  'dokku'
    group  'dokku'
    action :create
    variables(
      "env" => config['env'] || {}
    )
    not_if { delete }
  end

  if config['tls']
    tls_directory = File.join(app_directory, 'tls')

    directory tls_directory do
      owner 'dokku'
      group 'dokku'
      action :create
      not_if { delete }
    end

    file File.join(tls_directory, 'server.crt') do
      content config['tls']['crt']
      owner 'dokku'
      group 'dokku'
      action :create
      not_if { delete }
    end

    file File.join(tls_directory, 'server.key') do
      content config['tls']['key']
      owner 'dokku'
      group 'dokku'
      action :create
      not_if { delete }
    end
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
