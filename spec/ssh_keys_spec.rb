require 'spec_helper'

describe 'dokku::ssh_keys' do
  let(:chef_runner) do 
    ChefSpec::Runner.new do |node|
      node.set['dokku']['ssh_keys'] = {
        'user' => 'not_a_valid_key',
        'user2' => 'not_a_valid_key'
      }
    end
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  it 'should upload all ssh keys' do
    expect(chef_run).to run_bash("sshcommand_acl-add_key")
  end
end
