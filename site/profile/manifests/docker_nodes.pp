class profile::docker_nodes {
  include docker
  
 file { '/tmp/Dockerfile':
  ensure => present,
  source => 'puppet:///modules/fleetdm/Dockerfile',
}

  docker::image { 'centos_fleetdm':
    ensure      => 'present',
    image_tag   => '7',
    docker_file => '/tmp/Dockerfile',
    subscribe   => File['/tmp/Dockerfile'],
    require     => [File['/tmp/Dockerfile'],Class['docker']],
  }

  docker::image { 'centos':
    ensure    => 'present',
    image_tag => '7',
    require   => Class['docker'],
  }
  
  docker::run {'osquery01.puppet.vm':
    image            => 'centos:7',
    ensure           => present,
    detach           => true,
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
