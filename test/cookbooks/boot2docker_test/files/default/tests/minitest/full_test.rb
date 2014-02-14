require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'boot2docker_test::full' do
  include Helpers::Boot2dockerTest

  it 'has busybox image installed' do
    assert image_exists?('busybox')
  end

  it 'has busybox sleep 1111 container running' do
    assert container_exists?('busybox','sleep 1111')
    assert container_running?('busybox','sleep 1111')
  end
end
