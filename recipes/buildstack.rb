# Docker build stack
if node['dokku']['buildstack']['use_prebuilt']
  docker_image node['dokku']['buildstack']['image_name'] do
    source node['dokku']['buildstack']['prebuilt_url']
    action :import
  end
else
  docker_image node['dokku']['buildstack']['image_name'] do
    source node['dokku']['buildstack']['stack_url']
    action :build
  end
end

# TODO: Custom buildpacks (?)
