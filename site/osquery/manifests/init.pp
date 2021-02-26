class osquery (
  String $version                             = 'installed',
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

  yumrepo { 'osquery-s3-rpm-repo':
    name        => 'osquery RPM repository - $basearch',
    enabled     => 1,
    descr       => 'osquery RPM repository',
    baseurl     => 'https://s3.amazonaws.com/osquery-packages/rpm/$basearch/',
    gpgcheck    => 1,
    gpgkey      => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-osquery',
    s3_enabled  => 1,
    assumeyes   => 1,
  }
  
  file { '/etc/pki/rpm-gpg/RPM-GPG-KEY-osquery':
    ensure => present,
    source => 'https://pkg.osquery.io/rpm/GPG',
  }
  
  package { 'osquery':
    ensure   => $osquery::version,
     require => [File['/etc/pki/rpm-gpg/RPM-GPG-KEY-osquery'],Yumrepo['osquery-s3-rpm-repo']],
  }
  
  user { 'osquery':
  ensure   => present,
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

  file { '/etc/systemd/system/osqueryd.service':
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
    content => template('osquery/osqueryd.erb'),
    notify  => Service['osqueryd'],
  }

  file { $config_file:
    ensure  => present,
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    links   => follow,
    content => template('osquery/osquery.conf.erb'),
    notify  => Service['osqueryd'],
  }

  file { $osquery_flagfile:
    ensure  => present,
    recurse => true,
    content => template('osquery/osquery.flags.erb'),
    mode    => '0440',
    owner   => 'osquery',
    group   => 'osquery',
    purge   => true,
    force   => true,
    notify  => Service['osqueryd'],
  }

  service { 'osqueryd':
    ensure     => $osquery::service,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [File['/etc/systemd/system/osqueryd.service'],Package['osquery']],
  }
}
