class profile::docker_nodes {
  include docker
  
   # fetch the docker image
  docker::image { 'centos':
    ensure    => 'present',
    require   => Class['docker'],
  }
  
  docker::run {'osquery01.puppet.vm':
    image            => 'centos',
    ensure           => present,
    detach           => true,
    command          => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
    extra_parameters => ['--interactive'],
    require => Docker::Image['centos'],
  }
  docker::run {'fleet.puppet.vm':
    image            => 'centos',
    ensure           => present,
    ports            => ['443:443'],
    extra_parameters => ['--interactive'],
    require => Docker::Image['centos'],
  }
}
