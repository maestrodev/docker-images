class maestro::params(
  $enabled             = true,
  $user                = 'maestro',
  $group               = 'maestro',
  $user_home           = '/var/local/maestro',
  $agent_user          = $::osfamily ? { 'Windows' => 'maestro', default => 'maestro_agent' },
  $agent_group         = 'maestro_agent',
  $agent_user_home     = $::osfamily ? { 'Windows' => 'C:\maestro-agent', default => '/var/local/maestro-agent' },
  $agent_user_password = undef,
  $repo                = {
    'url' => 'https://repo.maestrodev.com/archiva/repository/all'
  },
  $logging_level       = 'INFO',
  $admin_username      = 'admin',
  $admin_password      = $maestro_adminpassword ? {undef => "admin1", default => $maestro_adminpassword},
  $lucee_password      = 'maestro',
  $lucee_username      = 'maestro',
  $stomp_username      = 'maestro',
  $stomp_password      = 'maestro',

  $db_server_password  = $maestro_db_server_password ? {undef => "maestro", default => $maestro_db_server_password},
  $db_username         = 'maestro',
  $db_password         = $maestro_db_password ? {undef => "maestro", default => $maestro_db_password},
  $db_host             = 'localhost',
  $db_port             = 5432,
  $db_version          = undef,
  $db_allowed_rules    = []) {

  $srcdir = '/usr/local/src'

  Exec {
    path => '/bin/:/usr/bin:/usr/sbin',
  }

  $package_type = $::osfamily ? {
    'RedHat'  => 'rpm',
    'Windows' => 'windows',
    default   => 'tarball',
  }

}
