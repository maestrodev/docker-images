class maestro::maestro::config($repo = $maestro::maestro::repo,
    $version = $maestro::maestro::version,
    $ldap = $maestro::maestro::ldap,
    $enabled = $maestro::params::enabled,
    $lucee = $maestro::maestro::lucee,
    $admin = $maestro::params::admin_username,
    $admin_password = $maestro::params::admin_password,
    $db_server_password = $maestro::params::db_server_password,
    $db_password = $maestro::params::db_password,
    $jdbc_users = $maestro::maestro::jdbc_users,
    $jdbc_maestro = $maestro::maestro::jdbc_maestro,
    $db_version = $maestro::params::db_version,
    $db_allowed_rules = $maestro::params::db_allowed_rules,
    $db_datadir = $maestro::maestro::db_datadir,
    $initmemory = $maestro::maestro::initmemory,
    $maxmemory = $maestro::maestro::maxmemory,
    $permsize = $maestro::maestro::permsize,
    $maxpermsize = $maestro::maestro::maxpermsize,
    $port = $maestro::maestro::port,
    $lucee_url = $maestro::maestro::lucee_url,
    $lucee_password = $maestro::params::lucee_password,
    $lucee_username = $maestro::params::lucee_username,
    $jetty_forwarded = $maestro::maestro::jetty_forwarded,
    $maestro_context_path = $maestro::maestro::maestro_context_path,
    $lucee_context_path = $maestro::maestro::lucee_context_path,
    $srcdir = $maestro::params::srcdir,
    $installdir = $maestro::maestro::installdir,
    $basedir = $maestro::maestro::basedir,
    $homedir = $maestro::maestro::homedir,
    $enable_jpda = $maestro::maestro::enable_jpda,
    $jmxport = $maestro::maestro::jmxport,
    $rmi_server_hostname = $maestro::maestro::rmi_server_hostname,
    $web_config_properties = $maestro::maestro::web_config_properties,
    $ga_property_id = $maestro::maestro::ga_property_id,
    $logging_level = $maestro::maestro::logging_level,
) inherits maestro::params {

  $configdir = "${basedir}/conf"
  $wrapper = "${configdir}/wrapper.conf"

  File {
    owner => $maestro::params::user,
    group => $maestro::params::group,
  }

  Augeas {
    lens      => "Properties.lns",
    require   => [Anchor['maestro::maestro::package::end']],
    notify    => Service['maestro'],
  }

  # Configure Maestro

  # sysconfig file with environment variables
  file { "/etc/sysconfig/maestro":
    content => template('maestro/sysconfig.erb'),
    notify  => Service['maestro'],
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  if !defined( File["${configdir}/jetty.xml"] ) {
    file { "${configdir}/jetty.xml":
      mode    => '0600',
      content => template('maestro/jetty.xml.erb'),
      }
  }
  file { "${configdir}/plexus.xml":
    mode    => '0600',
    content => template('maestro/plexus.xml.erb'),
  }

  file { "${configdir}/jetty-jmx.xml":
    mode    => '0600',
    content => template('maestro/jetty-jmx.xml.erb'),
  }

  file { "${configdir}/maestro.properties":
    mode    => '0600',
    content => template('maestro/maestro.properties.erb'),
    notify  => Service['maestro'],
  }

  file { "${configdir}/lucee-lib.json":
    mode    => '0600',
    content => template('maestro/lucee-lib.json.erb'),
    notify  => Service['maestro'],
  }
  if versioncmp($version, "4.13.0") >= 0 {
    # remove legacy hardcoded location
    file { '/var/maestro/lucee-lib.json':
      ensure => absent,
      require => Class['maestro::maestro::package'],
    }
  }
  else {
    # legacy hardcoded location
    file { '/var/maestro':
      ensure => directory,
    } ->
    file { '/var/maestro/lucee-lib.json':
      ensure => link,
      force  => true,
      target => "${basedir}/conf/lucee-lib.json",
    }
  }

  # Create symlinks to some files provided by the distribution package

  # not needed in Maestro 4.18.0+ RPM
  if ($maestro::maestro::package_type == 'tarball') or (versioncmp($maestro::maestro::version, '4.18.0') < 0) {
    file { "${configdir}/wrapper.conf":
      ensure  => link,
      target  => "${homedir}/conf/wrapper.conf",
      require => [Class['maestro::maestro::package'], File[$configdir]],
    }

    file { "${configdir}/webdefault.xml":
      ensure  => link,
      target  => "${homedir}/conf/webdefault.xml",
      require => [Class['maestro::maestro::package'], File[$configdir]],
    }

    file { "${configdir}/default-configurations.xml":
      ensure  => link,
      target  => "${homedir}/conf/default-configurations.xml",
      require => [Class['maestro::maestro::package'], File[$configdir]],
    }
  }

  # Tweak the files provided in the distribution as these cannot be templated easily or in a portable fashion.

  augeas { 'update-default-configurations':
    changes => [
      "set default-configuration/users/*/password/#text[../../username/#text = 'admin'] ${admin_password}",
      "rm default-configuration/users/*[username/#text != 'admin' and username/#text != 'guest']",
      "set default-configuration/users/*/username/#text[../../username/#text = 'admin'] ${admin}",
    ],
    incl    => "${basedir}/conf/default-configurations.xml",
    lens    => 'Xml.lns',
  }

  # Only works with log4j.xml when no DTD
  if versioncmp($version, "5.0.3") >= 0 {
    $level = downcase($logging_level)
    augeas { 'update-log4j':
      changes => [
        "set log4j:configuration/root/level/#attribute/value $level",
      ],
      incl    => "${homedir}/apps/maestro/WEB-INF/classes/log4j.xml",
      lens    => 'Xml.lns',
    }
  }

  if $initmemory != undef {
    augeas { 'maestro-wrapper-initmemory':
      incl      => $wrapper,
      changes   => [ "set wrapper.java.initmemory ${initmemory}" ],
    }
  }
  if $maxmemory != undef {
    augeas { 'maestro-wrapper-maxmemory':
      incl      => $wrapper,
      changes   => [ "set wrapper.java.maxmemory ${maxmemory}" ],
    }
  }
  if $permsize != undef {
    augeas { 'maestro-wrapper-permsize':
      incl      => $wrapper,
      changes   => [ "set *[. =~ regexp('-XX:PermSize=.*')] -XX:PermSize=${permsize}" ],
    }
  }
  if $maxpermsize != undef {
    augeas { 'maestro-wrapper-maxpermsize':
      incl      => $wrapper,
      changes   => [ "set *[. =~ regexp('-XX:MaxPermSize=.*')] -XX:MaxPermSize=${maxpermsize}" ],
    }
  }

  if $enable_jpda {
    # TODO: make more flexible by calculating the right number for the
    # parameter instead of hard-coding 13. Will require a Ruby function. Add
    # one to:
    #   cat $wrapper | egrep -c '^wrapper.java.additional.[0-9]+\s*='
    augeas { 'maestro-jpda':
      incl      => $wrapper,
      changes   => 'set wrapper.java.additional.13 -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n',
    }
  }

  if $::architecture == 'x86_64' {
    file { "${homedir}/bin/wrapper-linux-x86-32":
      ensure  => absent,
      require => Class['maestro::maestro::package'],
      before  => Service[maestro],
    }
  }
}
