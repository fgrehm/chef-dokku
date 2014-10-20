require 'spec_helper'

describe 'dokku::apps' do
  let(:chef_runner) do 
    ChefSpec::Runner.new do |node|
      node.set['dokku']['apps'] = {
        'testapp' => {
          'env' => {
            'var1' => 'a',
            'var2' => 'b'
          }
        },
        'testapp2' => {
          'remove' => true
        },
        'testapp3' => {
          'tls' => {
            'cert_file' => '/etc/ssl/certs/my.pem',
            'key_file' => '/etc/ssl/private/my.key'
          }
        }
      }
    end
  end
  let(:chef_run) { chef_runner.converge described_recipe }

  it 'should create the testapp directory under /home/dokku' do
    expect(chef_run).to create_directory '/home/dokku/testapp'
  end

  it 'should set the ownership of the testapp directory to dokku:dokku' do
    app1_dir = chef_run.directory('/home/dokku/testapp')
    expect(app1_dir.owner).to eq('dokku')
    expect(app1_dir.group).to eq('dokku')
  end

  it 'should delete the testapp2 directory under /home/dokku' do
    expect(chef_run).to delete_directory '/home/dokku/testapp2'
  end

  it 'should remove the app/testapp2 docker container' do
    expect(chef_run).to remove_docker_container 'app/testapp2'
  end

  it 'should remove the app/testapp2 docker image' do
    expect(chef_run).to remove_docker_image 'app/testapp2'
  end

  it 'should not create an ENV file for testapp2' do
    expect(chef_run).to_not create_file '/home/dokku/testapp2/ENV'
  end

  it 'should create the an ENV for testapp' do
    expect(chef_run).to render_file("/home/dokku/testapp/ENV").with_content("export VAR1='a'\nexport VAR2='b'")
  end

  it 'should set the ownership of the ENV file to git:git' do
    env_file = chef_run.template('/home/dokku/testapp/ENV')
    expect(env_file.owner).to eq('dokku')
    expect(env_file.group).to eq('dokku')
  end

  it 'should create a tls directory for testapp3' do
    expect(chef_run).to create_directory '/home/dokku/testapp3/tls'
  end

  it 'should create a server.crt link for testapp3' do
    expect(chef_run.link('/home/dokku/testapp3/tls/server.crt')).to link_to('/etc/ssl/certs/my.pem')
  end

  it 'should create a server.key link for testapp3' do
    expect(chef_run.link('/home/dokku/testapp3/tls/server.key')).to link_to('/etc/ssl/private/my.key')
  end

  it 'should not create an tls directory for testapp2' do
    expect(chef_run).to_not create_directory '/home/dokku/testapp2/tls'
  end
end
