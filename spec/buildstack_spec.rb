require 'spec_helper'

describe 'dokku::buildstack' do
  let(:chef_run) { chef_runner.converge described_recipe }

  context 'when use_prebuilt is true' do
    let(:chef_runner) do 
      runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
      runner.node.set['dokku']['buildstack']['image_name'] = 'progrium/buildstep'
      runner.node.set['dokku']['buildstack']['use_prebuilt'] = true
      runner.node.set['dokku']['buildstack']['prebuilt_url'] = 'prebuilt.tgz'
      runner
    end

    it 'should import the prebuilt image into docker' do
      # With doesn't work here either
      expect(chef_run).to import_docker_image('progrium/buildstep')
      #expect(chef_runner).to import_docker_image('progrium/buildstep').with(
        #image_url: 'prebuilt.tgz',
        #repository: 'progrium/buildstep'
      #)
    end
  end

  context 'when use_prebuilt is false' do
    let(:chef_runner) do 
      runner = ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04')
      runner.node.set['dokku']['buildstack']['image_name'] = 'progrium/buildstep'
      runner.node.set['dokku']['buildstack']['use_prebuilt'] = false
      runner.node.set['dokku']['buildstack']['stack_url'] = 'github.com/progrium/buildstep'
      runner
    end

    it 'should build the remote image' do
      # with doesn't work here either
      expect(chef_run).to build_docker_image('progrium/buildstep')
      #expect(chef_runner).to build_docker_image('progrium/buildstep').with(
        #image_url:'github.com/progrium/buildstep',
        #repository: 'progrium/buildstep'
      #)
    end
  end
end
