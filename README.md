# chef-boot2docker [![Build Status](https://secure.travis-ci.org/bflad/chef-boot2docker.png?branch=master)](http://travis-ci.org/bflad/chef-boot2docker)

## Description

Installs/Configures [boot2docker](https://github.com/steeve/boot2docker/).

For controlling docker containers, images, etc. once boot2docker is installed and configured, check out the LWRPs of the [docker cookbook](https://github.com/bflad/chef-docker/).

## Requirements

### Chef

* Chef 10.10+

### Platforms

* CentOS 6
* Debian 7 (experimental)
* Fedora 19
* Fedora 20
* Mac OS X (only boot2docker installation currently)
* Oracle 6 (experimental)
* RHEL 6
* Ubuntu 12.04
* Ubuntu 12.10
* Ubuntu 13.04
* Ubuntu 13.10 (experimental)

### Cookbooks

[Opscode Cookbooks](https://github.com/opscode-cookbooks/)

* [apt](https://github.com/opscode-cookbooks/apt)
* [ark](https://github.com/opscode-cookbooks/ark)
* [git](https://github.com/opscode-cookbooks/git)
* [homebrew](https://github.com/opscode-cookbooks/homebrew)

Third-Party Cookbooks

* (Recommended) [docker](http://community.opscode.com/cookbooks/docker)
* (Recommended) [virtualbox](http://community.opscode.com/cookbooks/virtualbox)

## Attributes

These attributes are under the `node['boot2docker']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
config_dir | Configuration directory | String | `#{::Dir.home}/.boot2docker`
cmd_timeout | boot2docker command timeout in seconds | Fixnum | 30
data_dir | Data directory to store ISO and VM disks | String | `node['boot2docker']['config_dir']`
docker_port | Host docker port | Fixnum | 4243
http_proxy | HTTP_PROXY environment variable | String | nil
init_type | Init type for boot2docker VMs (nil, "systemd", "sysv", or "upstart") | NilClass or String | auto-detected (see attributes/default.rb)
install_dir | Installation directory for boot2docker | String | auto-detected (see attributes/default.rb)
install_type | Installation type for boot2docker ("binary", "package" or "source") | String | auto-detected (see attributes/default.rb)
ssh_port | Host SSH port | Fixnum | 2022
version | Version of boot2docker | String | '0.5.4'

### Binary Attributes

These attributes are under the `node['boot2docker']['binary']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
url | URL for downloading boot2docker binary | String | `https://github.com/steeve/boot2docker/archive/v#{node['boot2docker']['version']}.tar.gz`

### ISO Attributes

These attributes are under the `node['boot2docker']['iso']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
install_dir | Installation directory for boot2docker ISO | String | `node['boot2docker']['data_dir']`
url | URL for downloading boot2docker ISO | String | `https://github.com/steeve/boot2docker/releases/download/v#{node['boot2docker']['version']}/boot2docker.iso`

### Package Attributes

These attributes are under the `node['boot2docker']['package']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
action | Action for boot2docker packages | String | install

### Source Attributes

These attributes are under the `node['boot2docker']['source']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
action | Repository action | String | sync
ref | Repository reference for boot2docker source | String | master
url | Repository URL for boot2docker source | String | https://github.com/steeve/boot2docker.git

### VM Attributes

These attributes are under the `node['boot2docker']['vm']` namespace.

Attribute | Description | Type | Default
----------|-------------|------|--------
disk | VM disk location | String | `#{node['boot2docker']['data_dir']}/#{node['boot2docker']['vm']['name']}.vmdk`
disk_size | VM disk size | Fixnum | 40, 000
memory | VM memory | Fixnum | 1024
name | VM name | String | boot2docker-vm

## Recipes

* `recipe[boot2docker]` Installs/Configures boot2docker
* `recipe[boot2docker::binary]` Installs boot2docker via binary
* `recipe[boot2docker::netcat]` Installs netcat
* `recipe[boot2docker::package]` Installs boot2docker via package
* `recipe[boot2docker::source]` Installs boot2docker via source

## Usage

### Default Installation

* Add `recipe[boot2docker]` to your node's run list

## Testing and Development

* Quickly testing with Vagrant: [VAGRANT.md](VAGRANT.md)
* Full development and testing workflow with Test Kitchen and friends: [TESTING.md](TESTING.md)

## Contributing

Please see contributing information in: [CONTRIBUTING.md](CONTRIBUTING.md)

## Maintainers

* Brian Flad (<bflad417@gmail.com>)

## License

Please see licensing information in: [LICENSE](LICENSE)
