case node['platform']
when 'max_os_x'
  homebrew_package 'boot2docker' do
    action node['boot2docker']['package']['action'].intern
  end
end
