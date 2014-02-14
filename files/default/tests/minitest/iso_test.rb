require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'boot2docker::iso' do
  include Helpers::Boot2docker

  it 'installs boot2docker.iso' do
    file("#{node['boot2docker']['iso']['install_dir']}/boot2docker.iso").must_exist
  end
end
