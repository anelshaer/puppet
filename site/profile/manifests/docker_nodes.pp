class profile::docker_nodes {
  include docker
  
 file { '/root/Dockerfile':
  ensure => file,
  source => 'puppet:///modules/fleetdm/Dockerfile',
}

  docker::image { 'centos_fleetdm':
    ensure      => present,
    image_tag   => '7',
    docker_file => '/root/Dockerfile',
    subscribe   => File['/root/Dockerfile'],
    require     => [File['/root/Dockerfile'],Class['docker']],
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
  
  docker::run {'fleet.puppet.vm':
    image            => 'centos:7',
    ensure           => present,
    ports            => ['443:443'],
    extra_parameters => ['--interactive'],
    require => Docker::Image['centos_fleetdm'],
  }
}
