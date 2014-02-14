# TODO: Move to netcat cookbook
case node['platform_family']
when 'debian'
  package 'netcat'
when 'fedora', 'rhel'
  package 'nc'
end
