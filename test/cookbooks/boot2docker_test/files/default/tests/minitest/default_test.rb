require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'boot2docker_test::default' do
  include Helpers::Boot2dockerTest
end
