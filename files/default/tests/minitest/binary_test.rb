require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'boot2docker::binary' do
  include Helpers::Boot2docker

  it 'installs boot2docker binary' do
    file("#{node['boot2docker']['install_dir']}/boot2docker").must_exist
  end
end
