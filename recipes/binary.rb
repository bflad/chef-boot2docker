directory node['boot2docker']['data_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

ark 'boot2docker' do
  url node['boot2docker']['binary']['url']
  prefix_root node['boot2docker']['data_dir']
  prefix_home node['boot2docker']['data_dir']
  version node['boot2docker']['version']
end

link "#{node['boot2docker']['install_dir']}/boot2docker" do
  to "#{node['boot2docker']['data_dir']}/boot2docker/boot2docker"
end
