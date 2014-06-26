require 'chefspec'
require 'chefspec/berkshelf'
require 'support/matchers'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '14.04'
end
