begin
  require 'rspec/core/rake_task'

  desc 'Run all specs'
  RSpec::Core::RakeTask.new

  desc 'Default task which runs all specs'
  task :default => :spec
rescue LoadError; end
