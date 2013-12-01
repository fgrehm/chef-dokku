# Corresponds to the $PLUGIN_PATH variable
default['dokku']['plugin_path'] = '/var/lib/dokku/plugins'

#  Hash, key is plugin name, value is git repo URL
default['dokku']['plugins'] = {}

# Needed for the nginx reload script
force_default['authorization']['sudo']['include_sudoers_d'] = true
