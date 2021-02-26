class profile::osquery (
  Boolean $enable                      = lookup('profile::osquery::enable', Boolean, 'deep', false),
  String  $version                     = lookup('profile::osquery::version', String, undef, ''),
  Enum['stopped', 'running'] $service  = lookup('profile::osquery::service', String, undef, 'running'),
  String  $cert                        = lookup('profile::osquery::cert', String, undef, ''),
  String  $enroll_secret               = lookup('profile::osquery::enroll_secret', String, undef, ''),
  String  $tls_hostname                = lookup('profile::osquery::tls_hostname', String, undef, ''),
  Boolean $enable_audit                = lookup('profile::osquery::enable_audit', Boolean, 'deep', false),
  Integer $events_max                  = lookup('profile::osquery::events_max', Integer, undef, 50000),
  Integer $events_expiry               = lookup('profile::osquery::events_expiry', Integer, undef, 3600),
) {
  if $enable {
    class { '::osquery::init':
      version              => $version,
      service              => $service,
      agent_cert           => $cert,
      agent_enroll_secret  => $enroll_secret,
      tls_hostname         => $tls_hostname,
      events_max           => $events_max,
      events_expiry        => $events_expiry,
      enable_audit         => $enable_audit,
    }
  }
}
