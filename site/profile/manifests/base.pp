class profile::base {
  user {'admin':
     ensure => present,
   }
   include profile::ssh_server
   include profile::osquery
 }
