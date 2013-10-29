require 'spec_helper'

describe 'dokku::install'do
  let(:chef_run) { ChefSpec::Runner.new.converge described_recipe }

  it "clones the dokku git repository" do
    expect(chef_run).to sync_git("/var/chef/cache/dokku")
  end

  it "installs dokku" do
    expect(chef_run).to run_bash('install_dokku').with(
      :cwd => "#{Chef::Config[:file_cache_path]}/dokku"
    )
  end
end
