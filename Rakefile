require "fileutils"
require "kitchen"
include FileUtils

# Stolen from https://github.com/drnic/chef-hub/blob/master/Rakefile
desc "Share cookbook"
task :share, [:version] do |t, args|
  unless version = args[:version]
    $stderr.puts "USAGE: rake share[1.2.3]"
    exit 1
  end
  project_folder = File.expand_path("..", __FILE__)
  name, _ = Kitchen::MetadataChopper.extract("./metadata.rb")
  parent_folder = "/tmp/cookbooks"
  tmp_cookbook_folder = File.join(parent_folder, name)
  rm_rf(tmp_cookbook_folder)
  mkdir_p(parent_folder)
  cp_r(project_folder, tmp_cookbook_folder)
  chdir(tmp_cookbook_folder) do
    sh "knife community release #{name} #{version} -o .."
  end
end
