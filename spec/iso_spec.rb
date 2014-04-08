require 'spec_helper'

describe 'boot2docker::iso' do
  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
