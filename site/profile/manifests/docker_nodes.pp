class profile::docker_nodes {
  include ::docker
  
   # fetch the docker image
  ::docker::image { 'centos':
    ensure    => 'present',
    require   => Class['docker'],
  }
  
  ::docker::run {'osquery01.puppet.vm':
    image    => 'centos',
    ensure   => present,
    require => Docker::Image['centos'],
  }
  ::docker::run {'fleet.puppet.vm':
    image    => 'centos',
    ensure   => present,
    ports   => ['443:443'],
    require => Docker::Image['centos'],
  }
}
