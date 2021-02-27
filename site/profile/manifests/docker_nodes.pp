class profile::docker_nodes {
  include docker
  
  docker::run {'osquery01.puppet.vm':
    image    => 'centos',
    ensure   => present,
    restart => 'always'
  }
  docker::run {'fleet.puppet.vm':
    image    => 'centos',
    ensure   => present,
  }
}