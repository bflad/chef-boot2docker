include Helpers::Boot2docker

def load_current_resource
  @current_resource = Chef::Resource::Boot2dockerVm.new(new_resource)
  wait_until_ready!
  bi = boot2docker_cmd('info')
  unless bi.stdout.include?('does not exist')
    Chef::Log.debug('Found boot2docker VM: ' + new_resource.name)
    @current_resource.name(new_resource.name)
  end
  @current_resource
end

action :delete do
  if running?
    stop
    new_resource.updated_by_last_action(true)
  end
  if exists?
    delete
    new_resource.updated_by_last_action(true)
  end
end

action :download do
  unless exists?
    download
    new_resource.updated_by_last_action(true)
  end
end

action :init do
  unless exists?
    init
    new_resource.updated_by_last_action(true)
  end
end

action :pause do
  if running?
    pause
    new_resource.updated_by_last_action(true)
  end
end

action :redeploy do
  stop if running?
  remove if exists?
  start
  new_resource.updated_by_last_action(true)
end

action :restart do
  if exists?
    restart
    new_resource.updated_by_last_action(true)
  end
end

action :start do
  unless running?
    start
    new_resource.updated_by_last_action(true)
  end
end

action :stop do
  if running?
    stop
    new_resource.updated_by_last_action(true)
  end
end

def command_timeout_error_message
  <<-EOM

Command timed out:
#{cmd}

Please adjust node cmd_timeout attribute or this boot2docker_vm cmd_timeout attribute if necessary.
EOM
end

def delete
  boot2docker_cmd!('delete')
  service_remove if service?
end

def download
  boot2docker_cmd!('download')
end

def exists?
  @current_resource.name
end

def init
  boot2docker_cmd!('init')
end

def pause
  boot2docker_cmd!('pause')
end

def restart
  if service?
    service_restart
  else
    boot2docker_cmd!('restart')
  end
end

def running?
  boot2docker_cmd('status').exitstatus
end

def service?
  # new_resource.init_type
  false
end

def service_action(actions)
  service service_name do
    case new_resource.init_type
    when 'systemd'
      provider Chef::Provider::Service::Systemd
    when 'upstart'
      provider Chef::Provider::Service::Upstart
    end
    supports :status => true, :restart => true, :reload => true
    action actions
  end
end

def service_create
  case new_resource.init_type
  when 'systemd'
    service_create_systemd
  when 'sysv'
    service_create_sysv
  when 'upstart'
    service_create_upstart
  end
end

def service_create_systemd
  template "/usr/lib/systemd/system/#{service_name}.socket" do
    if new_resource.socket_template.nil?
      source 'boot2docker-container.socket.erb'
    else
      source new_resource.socket_template
    end
    cookbook new_resource.cookbook
    mode '0644'
    owner 'root'
    group 'root'
    variables(
      :service_name => service_name,
      :sockets => sockets
    )
    not_if port.empty?
  end

  template "/usr/lib/systemd/system/#{service_name}.service" do
    source service_template
    cookbook new_resource.cookbook
    mode '0644'
    owner 'root'
    group 'root'
    variables(
      :cmd_timeout => new_resource.cmd_timeout,
      :service_name => service_name
    )
  end

  service_action([:start, :enable])
end

def service_create_sysv
  template "/etc/init.d/#{service_name}" do
    source service_template
    cookbook new_resource.cookbook
    mode '0755'
    owner 'root'
    group 'root'
    variables(
      :cmd_timeout => new_resource.cmd_timeout,
      :service_name => service_name
    )
  end

  service_action([:start, :enable])
end

def service_create_upstart
  # The upstart init script requires inotifywait, which is in inotify-tools
  package 'inotify-tools'

  template "/etc/init/#{service_name}.conf" do
    source service_template
    cookbook new_resource.cookbook
    mode '0600'
    owner 'root'
    group 'root'
    variables(
      :cmd_timeout => new_resource.cmd_timeout,
      :service_name => service_name
    )
  end

  service_action([:start, :enable])
end

def service_name
  new_resource.name
end

def service_remove
  case new_resource.init_type
  when 'systemd'
    service_remove_systemd
  when 'sysv'
    service_remove_sysv
  when 'upstart'
    service_remove_upstart
  end
end

def service_remove_systemd
  service_action([:stop, :disable])

  %w(service socket).each do |f|
    file "/usr/lib/systemd/system/#{service_name}.#{f}" do
      action :delete
    end
  end
end

def service_remove_sysv
  service_action([:stop, :disable])

  file "/etc/init.d/#{service_name}" do
    action :delete
  end
end

def service_remove_upstart
  service_action([:stop, :disable])

  file "/etc/init/#{service_name}" do
    action :delete
  end
end

def service_restart
  service_action([:restart])
end

def service_start
  service_action([:start])
end

def service_stop
  service_action([:stop])
end

def service_template
  return new_resource.init_template unless new_resource.init_template.nil?
  case new_resource.init_type
  when 'systemd'
    'boot2docker-container.service.erb'
  when 'upstart'
    'boot2docker-container.conf.erb'
  when 'sysv'
    'boot2docker-container.sysv.erb'
  end
end

def start
  if service?
    service_create
  else
    boot2docker_cmd!('start')
  end
end

def stop
  if service?
    service_stop
  else
    boot2docker_cmd!('stop')
  end
end
