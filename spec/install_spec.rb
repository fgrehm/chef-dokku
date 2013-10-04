require 'spec_helper'

describe 'dokku::install'do
  let(:chef_run) { ChefSpec::ChefRunner.new.converge described_recipe }

  # Need ChefSpec v3
  #it "clones the dokku git repository" do
    #expect(chef_run).to checkout_git "https://github.com/progrium/dokku.git"
  #end

  it "installs dokku" do
    expect(chef_run).to execute_bash_script('install_dokku').with(
      :cwd => "#{Chef::Config[:file_cache_path]}/dokku"
    )
  end
end
