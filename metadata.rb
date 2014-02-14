name              'boot2docker'
maintainer        'Brian Flad'
maintainer_email  'bflad417@gmail.com'
license           'Apache 2.0'
description       'Installs/Configures boot2docker'
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.0'
recipe            'boot2docker', 'Installs/Configures boot2docker'
recipe            'boot2docker::binary', 'Installs boot2docker via binary'
recipe            'boot2docker::netcat', 'Installs netcat'
recipe            'boot2docker::package', 'Installs boot2docker via package'
recipe            'boot2docker::source', 'Installs boot2docker via source'

supports 'centos', '>= 6.0'
supports 'debian', '>= 7.0'
supports 'fedora', '>= 19.0'
supports 'mac_os_x'
supports 'mac_os_x_server'
supports 'oracle', '>= 6.0'
supports 'redhat', '>= 6.0'
supports 'ubuntu', '>= 12.04'

depends 'apt'
depends 'ark'
depends 'git'
depends 'homebrew'
