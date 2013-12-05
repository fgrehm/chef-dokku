require 'spec_helper'

describe 'dokku::buildstack' do
  let(:chef_run) { chef_runner.converge described_recipe }

  context 'when use_prebuilt is true' do
    let(:chef_runner) do 
      ChefSpec::Runner.new do |node|
        node.set['dokku']['buildstack']['image_name'] = 'progrium/buildstep'
        node.set['dokku']['buildstack']['use_prebuilt'] = true
        node.set['dokku']['buildstack']['prebuilt_url'] = 'prebuilt.tgz'
      end
    end

    it 'should import the prebuilt image into docker' do
      expect(chef_run).to import_docker_image('progrium/buildstep').with(
        image_url: 'prebuilt.tgz'
      )
    end
  end

  context 'when use_prebuilt is false' do
    let(:chef_runner) do 
      ChefSpec::Runner.new do |node|
        node.set['dokku']['buildstack']['image_name'] = 'progrium/buildstep'
        node.set['dokku']['buildstack']['use_prebuilt'] = false
        node.set['dokku']['buildstack']['stack_url'] = 'github.com/progrium/buildstep'
      end
    end

    it 'should build the remote image' do
      expect(chef_run).to build_docker_image('progrium/buildstep').with(
        image_url:'github.com/progrium/buildstep'
      )
    end
  end
end
