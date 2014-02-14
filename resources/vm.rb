actions :delete, :download, :init, :pause, :restart, :start, :stop

default_action :init

attribute :name, :name_attribute => true

attribute :boot2docker_iso, :kind_of => [String], :default => "#{node['boot2docker']['iso']['install_dir']}/boot2docker.iso"
attribute :cmd_timeout, :kind_of => [Integer], :default => node['boot2docker']['cmd_timeout']
attribute :docker_port, :kind_of => [Fixnum], :default => node['boot2docker']['docker_port']
attribute :disk, :kind_of => [String], :default => node['boot2docker']['vm']['disk']
attribute :disk_size, :kind_of => [Fixnum], :default => node['boot2docker']['vm']['disk_size']
attribute :init_type, :kind_of => [FalseClass, String], :default => node['boot2docker']['init_type']
attribute :memory, :kind_of => [Fixnum], :default => node['boot2docker']['vm']['memory']
attribute :ssh_port, :kind_of => [Fixnum], :default => node['boot2docker']['ssh_port']
