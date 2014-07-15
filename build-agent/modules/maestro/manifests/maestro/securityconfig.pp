class maestro::maestro::securityconfig(
  $ldap            = $maestro::maestro::ldap,
  $master_password = $maestro::maestro::master_password,
  $mail_from       = $maestro::maestro::mail_from,
  $basedir         = $maestro::maestro::basedir) inherits maestro::params {

  File {
    owner => $maestro::params::user,
    group => $maestro::params::group,
  }
  # Configure Maestro
  file { "${basedir}/conf/security.properties":
    mode    => '0644',
    content => template('maestro/security.properties.erb'),
  }
}
