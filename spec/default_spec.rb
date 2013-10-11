require 'spec_helper'

describe 'dokku::default' do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge described_recipe }
end
