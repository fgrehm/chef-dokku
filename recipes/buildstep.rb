# Docker build stack
if node['dokku']['buildstep']['use_prebuilt']
  docker_image node['dokku']['buildstep']['image_name'] do
    image_url node['dokku']['buildstep']['prebuilt_url']
    action :import
  end
else
  docker_image node['dokku']['buildstep']['image_name'] do
    image_url node['dokku']['buildstep']['stack_url']
    action :build
  end
end

# TODO: Custom buildpacks (?)
