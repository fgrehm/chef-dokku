require 'spec_helper'

describe 'dokku::install'do
  let(:chef_runner) do
    ChefSpec::Runner.new
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  it 'syncs the dokku git repository' do
    expect(chef_run).to sync_git('/var/chef/cache/dokku').with(
      repository: 'https://github.com/progrium/dokku.git',
      reference: 'v0.2.0'
    )
  end

  context 'sync base is false' do
    let(:chef_runner) do
      ChefSpec::Runner.new do |node|
        node.set['dokku']['sync']['base'] = false
      end
    end

    it 'checks out the dokku git repository' do
      expect(chef_run).to checkout_git('/var/chef/cache/dokku').with(
        repository: 'https://github.com/progrium/dokku.git',
        reference: 'v0.2.0'
      )
    end
  end

  it "copies the dokku files" do
    expect(chef_run).to run_bash('copy_dokku_files').with(
      :cwd => "#{Chef::Config[:file_cache_path]}/dokku"
    )
  end
end
