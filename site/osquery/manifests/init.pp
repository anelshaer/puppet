class osquery::init (
  String $version                             = 'latest',
  Enum['stopped', 'running'] $service         = 'running',
  Stdlib::Unixpath  $config_file              = '/etc/osquery/osquery.conf',
  Stdlib::Unixpath  $enroll_secret_path       = '/etc/osquery/osquery_enroll_secret',
  Stdlib::Unixpath  $cert_file                = '/etc/osquery/osquery_cert.pem',
  Stdlib::Unixpath  $osqueryd_sysconfig       = '/etc/sysconfig/osqueryd',
  Stdlib::Unixpath  $osquery_flagfile         = '/etc/osquery/osquery.flags',
  Stdlib::Unixpath  $logger_path              = '/var/log/osquery/logs',
  Stdlib::Unixpath  $database_path            = '/var/log/osquery/db/osquery.db',
  Stdlib::Unixpath  $results_log              = '/var/log/osquery/logs/osqueryd.results.log',
  Stdlib::Unixpath  $snapshot_log             = '/var/log/osquery/logs/osqueryd.snapshots.log',
  String  $cert                               = '',
  String  $enroll_secret                      = '',
  String  $tls_hostname                       = 'fleet.puppet.vm',
  Integer $events_max                         = 50000,
  Integer $events_expiry                      = 3600,
  Boolean $enable_audit                       = true,
) {

  package { 'osquery':
    ensure   => $osquery::init::version,
  }

  file { '/etc/osquery':
    ensure => directory,
    owner  => 'osquery',
    group  => 'osquery',
    mode   => '0550',
  }

  file { '/var/log/osquery':
    ensure => directory,
    owner  => 'osquery',
    group  => 'osquery',
    mode   => '0775',
  }

  file { '/var/log/osquery/logs':
    ensure => directory,
    owner  => 'osquery',
    group  => 'osquery',
    mode   => '0775',
  }

  file { '/var/log/osquery/db':
    ensure => directory,
    owner  => 'osquery',
    group  => 'osquery',
    mode   => '0775',
  }

  systemd::unit_file { 'osqueryd.service':
    ensure => present,
    source => 'puppet:///modules/osquery/osqueryd.service',
  }

  file { $results_log:
    ensure => present,
    owner  => 'root',
    group  => 'osquery',
  }

  file { $snapshot_log:
    ensure => present,
    owner  => 'root',
    group  => 'osquery',
  }

file { $cert_file:
    ensure  => present,
    recurse => true,
    content => $cert,
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    purge   => true,
    force   => true,
    notify  => Service['osqueryd'],
  }

  file { $enroll_secret_path:
    ensure  => present,
    recurse => true,
    content => $enroll_secret,
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    purge   => true,
    force   => true,
    notify  => Service['osqueryd'],
  }

  file { $osqueryd_sysconfig:
    ensure  => present,
    recurse => true,
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    purge   => true,
    force   => true,
    content => template('osquery/init/osqueryd.erb'),
    notify  => Service['osqueryd'],
  }

  file { $config_file:
    ensure  => present,
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    links   => follow,
    content => template('osquery/init/osquery.conf.erb'),
    notify  => Service['osqueryd'],
  }

  file { $osquery_flagfile:
    ensure  => present,
    recurse => true,
    content => template('osquery/int/osquery.flags.erb'),
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    purge   => true,
    force   => true,
    notify  => Service['osqueryd'],
  }

  service { 'osqueryd':
    ensure     => $osquery::init::service,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['osquery'],
    subscribe  => Systemd::Unit_file['osqueryd.service'],
  }
}
