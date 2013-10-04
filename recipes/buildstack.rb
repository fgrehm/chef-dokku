# Docker build stack
docker_image node['dokku']['buildstack']['image_name'] do
  image_url node['dokku']['buildstack']['prebuilt_url']
  repository node['dokku']['buildstack']['image_name']
  action node['dokku']['buildstack']['use_prebuilt'] ? 'import' : 'build'
end
