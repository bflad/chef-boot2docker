include_recipe 'virtualbox'
include_recipe 'boot2docker'

docker_image 'busybox'

docker_container 'busybox' do
  command 'sleep 1111'
  detach true
  init_type false
end
