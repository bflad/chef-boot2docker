# Helpers module for minitest
module Helpers
  # Helpers::Boot2docker module for minitest
  module Boot2docker
    include MiniTest::Chef::Assertions
    include MiniTest::Chef::Context
    include MiniTest::Chef::Resources
  end
end
