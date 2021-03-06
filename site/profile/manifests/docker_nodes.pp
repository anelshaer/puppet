class profile::docker_nodes {
  include docker

 file { '/root/docker-compose.yml':
  ensure => file,
  source => 'puppet:///modules/fleetdm/docker-compose.yml',
  }

  docker::image { 'centos':
    ensure    => present,
    image_tag => '7',
    require   => Class['docker'],
  }
  
  docker::run {'osquery01.puppet.vm':
    image            => 'centos:7',
    ensure           => present,
    extra_parameters => ['--interactive'],
    require => Docker::Image['centos'],
  }
  
  docker_compose { 'fleetdm':
    compose_files => ['/root/docker-compose.yml'],
    ensure  => present,
    subscribe   => File['/root/docker-compose.yml'],
  }
}
