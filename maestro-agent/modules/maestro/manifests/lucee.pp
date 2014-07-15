class maestro::lucee(
  $config_dir  = '/var/local/maestro/conf',
  $agent_auto_activate = false,
  $lucee_username      = $maestro::params::lucee_username,
  $lucee_password      = $maestro::params::lucee_password,
  $stomp_username      = $maestro::params::stomp_username,
  $stomp_password      = $maestro::params::stomp_password,
  $username            = $maestro::lucee::db::username,
  $password            = $maestro::lucee::db::password,
  $type                = $maestro::lucee::db::type,
  $host                = $maestro::lucee::db::host,
  $port                = $maestro::lucee::db::port,
  $messenger_debugging = false,
  $logging_level       = $maestro::params::logging_level,
  $database            = $maestro::lucee::db::database,
  $metrics_enabled     = false,
  $is_demo             = false) inherits maestro::lucee::db {

  # We must make sure this file replaces the one installed
  # by the RPM package.

  file { "${config_dir}/maestro_lucee.json":
    ensure  => present,
    owner   => root,
    group   => root,
    content => template('maestro/lucee/maestro_lucee.json.erb'),
    notify  => Service['maestro'],
    require => Anchor['maestro::maestro::package::end'],
  }

  # Remove legacy file.
  if $config_dir != '/etc' {
    file { '/etc/maestro_lucee.json':
      ensure => absent,
      require => Anchor['maestro::maestro::package::end'],
    }
  }
}
