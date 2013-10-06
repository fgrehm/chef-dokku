require 'spec_helper'

describe 'dokku::ssh_keys' do
  let(:chef_runner) do 
    runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
    runner.node.set['dokku']['ssh_keys'] = {
      'user' => 'not_a_valid_key',
      'user2' => 'not_a_valid_key'
    }
    runner
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  it 'should upload all ssh keys' do
    expect(chef_run).to execute_bash_script('gitrecieve_upload-key')
  end
end
