require 'chefspec'
require 'chefspec/berkshelf'
require 'support/matchers'

RSpec.configure do |config|
  config.log_level = :error
  config.platform = 'ubuntu'
  config.version = '12.04' # needs to be 13.04 when fauxhai gets that data
end
