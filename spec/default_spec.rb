require 'spec_helper'

describe 'dokku::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }
end
