require 'chefspec'
require 'berkshelf'

berksfile = Berkshelf::Berksfile.from_file('Berksfile')
berksfile.install(path: 'vendor/cookbooks')

# Define matchers for the docker LWRPs
# Kill this off in ChefSpec v3 since chef-docker should ship with
# its own matchers

module ChefSpec
  module Matchers
    define_resource_matchers([:pull, :build, :remove, :import], [:docker_image], :name)
    define_resource_matchers([:remove, :restart, :run, :start, :stop], [:docker_container], :name)
  end
end
