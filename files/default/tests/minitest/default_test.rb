require File.expand_path('../support/helpers', __FILE__)

describe_recipe 'boot2docker::default' do
  include Helpers::Boot2docker
end
