require 'spec_helper'

describe 'dokku::plugins' do
  let(:chef_runner) do 
    runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
    runner.node.set['dokku']['plugins_dir'] = '/var/lib/dokku/plugins'
    runner
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  #TODO: write specs for the git clones
  #Need ChefSpec v3 to do that

  it 'should run dokku_plugins_install' do
    expect(chef_run).to execute_bash_script('dokku_plugins_install').with(
      :cwd => '/var/lib/dokku/plugins'
    )
  end
  
end
