directory node['boot2docker']['data_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

git "#{node['boot2docker']['data_dir']}/boot2docker" do
  repository node['boot2docker']['source']['url']
  reference node['boot2docker']['source']['ref']
  action node['boot2docker']['source']['action'].intern
end

link "#{node['boot2docker']['install_dir']}/boot2docker" do
  to "#{node['boot2docker']['data_dir']}/boot2docker/boot2docker"
end
