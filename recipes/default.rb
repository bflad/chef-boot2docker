include_recipe 'apt' if node['platform_family'] == 'debian'
include_recipe 'git' if node['boot2docker']['install_type'] == 'source'
include_recipe 'boot2docker::netcat'

include_recipe "boot2docker::#{node['boot2docker']['install_type']}"
include_recipe 'boot2docker::iso'

boot2docker_vm node['boot2docker']['vm']['name'] do
  action [:init, :start]
  only_if { node['boot2docker']['vm']['name'] }
end
