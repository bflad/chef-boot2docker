default['boot2docker']['cmd_timeout'] = 30
# TODO: Submit fix to customize configuration dir for system-wide usage
# (e.g. /etc/boot2docker or /var/lib/boot2docker)
default['boot2docker']['config_dir'] = "#{::Dir.home}/.boot2docker"
default['boot2docker']['data_dir'] = node['boot2docker']['config_dir']
default['boot2docker']['docker_port'] = 4243
default['boot2docker']['http_proxy'] = nil

default['boot2docker']['init_type'] = value_for_platform(
  %w{ centos oracle redhat scientific } => {
    %w{ 5 6 } => 'sysv',
    'default' => 'systemd'
  },
  %w{ debian } => {
    'default' => 'sysv'
  },
  %w{ fedora } => {
    'default' => 'systemd'
  },
  %w{ mac_os_x mac_os_x_server } => {
    'default' => nil
  },
  %w{ ubuntu } => {
    'default' => 'upstart'
  },
  'default' => 'upstart'
)

default['boot2docker']['install_type'] = value_for_platform(
  %w{ mac_os_x mac_os_x_server } => {
    'default' => 'package'
  },
  'default' => 'binary'
)

default['boot2docker']['install_dir'] =
  if %w{ mac_os_x mac_os_x_server}.include?(node['platform']) && node['boot2docker']['install_type'] == 'package'
    '/usr/local/bin'
  else
    '/usr/bin'
  end

default['boot2docker']['ssh_port'] = 2022
default['boot2docker']['version'] = '0.5.4'

# Binary attributes
default['boot2docker']['binary']['url'] = "https://github.com/steeve/boot2docker/archive/v#{node['boot2docker']['version']}.tar.gz"

# ISO attributes
default['boot2docker']['iso']['install_dir'] = node['boot2docker']['data_dir']
default['boot2docker']['iso']['url'] = "https://github.com/steeve/boot2docker/releases/download/v#{node['boot2docker']['version']}/boot2docker.iso"

# Package attributes
default['boot2docker']['package']['action'] = 'install'

# Source attributes
default['boot2docker']['source']['action'] = 'sync'
default['boot2docker']['source']['ref'] = 'master'
default['boot2docker']['source']['url'] = 'https://github.com/steeve/boot2docker.git'

# VM attributes
default['boot2docker']['vm']['name'] = 'boot2docker-vm'
default['boot2docker']['vm']['disk'] = "#{node['boot2docker']['data_dir']}/#{node['boot2docker']['vm']['name']}.vmdk"
default['boot2docker']['vm']['disk_size'] = 40, 000
default['boot2docker']['vm']['memory'] = 1024
