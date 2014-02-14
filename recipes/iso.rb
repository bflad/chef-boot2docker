directory node['boot2docker']['iso']['install_dir'] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file "#{node['boot2docker']['iso']['install_dir']}/boot2docker-#{node['boot2docker']['version']}.iso" do
  source node['boot2docker']['iso']['url']
  action :create_if_missing
end

link "#{node['boot2docker']['iso']['install_dir']}/boot2docker.iso" do
  to "#{node['boot2docker']['iso']['install_dir']}/boot2docker-#{node['boot2docker']['version']}.iso"
end
