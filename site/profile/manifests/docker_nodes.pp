class profile::docker_nodes {
  include docker
  
  docker::run {'osquery01.puppet.vm':
    image    => 'centos',
    ensure   => present,
    command  => '/bin/sh -c "while true; do echo hello world; sleep 1; done"',
  }
  docker::run {'fleet.puppet.vm':
    image    => 'centos',
    ensure   => present,
  }
}
