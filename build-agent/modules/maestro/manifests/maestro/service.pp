class maestro::maestro::service(
  $enabled     = $maestro::params::enabled,
  $db_password = $maestro::params::db_password,
  $jdbc_users  = $maestro::maestro::jdbc_users,
  $basedir     = $maestro::maestro::basedir,
  $port        = $maestro::maestro::port,
  $lucee       = $maestro::maestro::lucee,
  $ldap        = $maestro::maestro::ldap) inherits maestro::params {

  # not needed in Maestro 4.18.0+ RPM
  if ($maestro::maestro::package_type == 'tarball') or (versioncmp($maestro::maestro::version, '4.18.0') < 0) {
    file { '/etc/init.d/maestro':
      owner   => 'root',
      mode    => '0755',
      content => template('maestro/maestro.erb'),
      require => Class['maestro::maestro::package'],
      notify  => Service['maestro'],
    }
  }

  # do this only for binary installations, not for webapp deployments
  # Wait for tables to be created on Maestro startup
  # not actually used in the maestro module but useful for other modules that need to depend on maestro db being ready
  $startup_wait_script = '/tmp/startup_wait.sh'
  if $enabled {
    file { $startup_wait_script:
      mode    =>  '0700',
      content =>  template('maestro/startup_wait.sh.erb'),
    } ->
    exec { "check-maestro-up":
      command     => "${startup_wait_script} ${db_password} >> ${basedir}/logs/maestro_initdb.log 2>&1",
      alias       => 'startup_wait',
      timeout     => 600,
      refreshonly => true,
      subscribe   => [Service[maestro]],
    }
    if $lucee {
      exec { 'check-data-upgrade':
        command     => "curl --noproxy localhost -X POST http://localhost:${port}/api/v1/system/upgrade",
        logoutput   => 'on_failure',
        tries       => 300,
        try_sleep   => 1,
        subscribe   => Exec['startup_wait'],
        refreshonly => true,
        path        => "/usr/bin",
      }
    }
  }

  # LDAP default system admin user, add permissions
  if !empty($ldap) {
    exec { 'insert-ldap-default-admin' :
      command     => "psql -h localhost -d maestro -U maestro -c \
      \"delete from userassignment where id=-1; insert into userassignment values(-1, '*', '${maestro::maestro::ldap['admin_user']}', (select id from role where name='System Administrator') );\"",
      unless      => "psql -h localhost -d maestro -U maestro -c \
      \"select username from userassignment where id=-1;\" | grep '${maestro::maestro::ldap['admin_user']}'",
      environment => "PGPASSWORD=${db_password}",
      path        => '/bin/:/usr/bin',
      logoutput   => true,
      require     => Exec['startup_wait'],
    }
  }

  $ensure_service = $enabled ? { true => running, false => stopped, }
  service { 'maestro':
    ensure     => $ensure_service,
    hasrestart => true,
    hasstatus  => true,
    enable     => $enabled,
    require    => [Class['maestro::maestro::package', 'maestro::maestro::db']],
    subscribe  => [File["${basedir}/conf/jetty.xml"], File["${basedir}/conf/security.properties"]],
  }
}
