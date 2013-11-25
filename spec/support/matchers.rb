# Define matchers for the docker LWRPs
# Need chef-docker to define its own LWRP matchers eventually

module DockerLWRPMatchers
  [:pull, :build, :remove, :import].each do |meth|
    self.send(:define_method,"#{meth}_docker_image") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(:docker_image, meth, resource_name)
    end
  end

  [:remove, :restart, :run, :start, :stop].each do |meth|
    self.send(:define_method,"#{meth}_docker_container") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(:docker_container, meth, resource_name)
    end
  end
end

include DockerLWRPMatchers

module SudoLWRPMatchers
  [:install, :remove].each do |meth|
    self.send(:define_method,"#{meth}_sudo") do |resource_name|
      ChefSpec::Matchers::ResourceMatcher.new(:sudo, meth, resource_name)
    end
  end
end

include SudoLWRPMatchers
