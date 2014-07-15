class maestro::agent::config(
  $srcdir = $maestro::params::srcdir,
  $basedir = $maestro::agent::basedir,
  $agent_user_home = $maestro::agent::agent_user_home,
  $agent_user = $maestro::agent::agent_user,
  $agent_group = $maestro::agent::agent_group,
  $maxmemory = $maestro::agent::maxmemory,
  $timestamp_version = $maestro::agent::agent_version,
  $facter = $maestro::agent::facter,
  $stomp_host = $maestro::agent::stomp_host,
  $stomp_username = $maestro::params::stomp_username,
  $stomp_password = $maestro::params::stomp_password,
  $maven_servers = $maestro::agent::maven_servers,
  $agent_name = $maestro::agent::agent_name,
  $enable_jpda = $maestro::agent::enable_jpda,
  $support_email = $maestro::agent::support_email,
  $logging_level = $maestro::params::logging_level,
  $jmxremote = $maestro::agent::jmxremote,
  $jmxport = $maestro::agent::jmxport,
  $rmi_server_hostname = $maestro::agent::rmi_server_hostname) inherits maestro::params {

  $wrapper = "${agent_user_home}/conf/wrapper.conf"

  file { 'maestro_agent.json':
    path    => "${agent_user_home}/conf/maestro_agent.json",
    content => template('maestro/agent/maestro_agent.json.erb'),
    owner   => $agent_user,
    group   => $agent_group,
    notify  => Service['maestro-agent'],
  }

  if $::osfamily == 'Windows' {
    # TODO: a way to install augeas on Windows, or just do it differently?
    notice('wrapper.conf modifications not yet supported on Windows')
  } else {

    Augeas {
      incl      => $wrapper,
      lens      => "Properties.lns",
      require   => [Anchor['maestro::agent::package::end']],
      notify    => Service['maestro-agent'],
    }

    # adjust wrapper.conf
    if $maxmemory != undef {
      augeas { "maestro-agent-wrapper-maxmemory":
        changes   => [
          "set wrapper.java.maxmemory ${maxmemory}",
        ],
      }
    }

    augeas { "maestro-agent-wrapper-debug-and-tmpdir":
      changes   => [
        # not needed for agents >= 2.1.0
        "set wrapper.java.additional.3 -XX:+HeapDumpOnOutOfMemoryError",
        "set wrapper.java.additional.4 -XX:HeapDumpPath=%MAESTRO_HOME%/logs",
        "set wrapper.java.additional.5 -Djava.io.tmpdir=%MAESTRO_HOME%/tmp",
      ],
    }

    if $jmxremote {
      augeas { "maestro-agent-wrapper-jmxremote":
        changes   => [
          "set wrapper.java.additional.6 -Dcom.sun.management.jmxremote",
          "set wrapper.java.additional.7 -Dcom.sun.management.jmxremote.port=${jmxport}",
          "set wrapper.java.additional.8 -Dcom.sun.management.jmxremote.authenticate=false",
          "set wrapper.java.additional.9 -Dcom.sun.management.jmxremote.ssl=false",
          "set wrapper.java.additional.10 -Djava.rmi.server.hostname=${rmi_server_hostname}",
        ],
      }
    } else {
      augeas { "maestro-agent-wrapper-jmxremote-disable":
      incl      => '/var/local/maestro-agent/conf/wrapper.conf',
      lens      => "Properties.lns",
        changes   => [
          "rm *[. =~ regexp('-Dcom.sun.management.jmxremote.*')]",
          "rm *[. =~ regexp('-Djava.rmi.server.hostname.*')]",
        ],
      }
    }

    if $enable_jpda {
      augeas { "maestro-agent-wrapper-jpda":
        changes   => [
          "set wrapper.java.additional.11 -Xrunjdwp:transport=dt_socket,address=8787,server=y,suspend=n",
        ],
      }
    }
  }

  # sysconfig / default file with environment variables
  case $::osfamily {
    'RedHat','Debian' : {

      $sysconfig_folder = $::osfamily ? {
        'RedHat' => '/etc/sysconfig',
        'Debian' => '/etc/default',
        default => ''
      }

      file { "${sysconfig_folder}/maestro-agent":
        content => template('maestro/agent/sysconfig.erb'),
        notify  => Service['maestro-agent'],
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
      }

      file { "${sysconfig_folder}/maestro_agent":
        ensure => absent,
      }

    }
  }

  # tarballs and older rpms
  if ($maestro::agent::package_type == 'tarball') or (versioncmp($maestro::agent::agent_version, '2.1.0') < 0) {

    file { "${srcdir}/maestro-agent.version":
      content => "${timestamp_version}\n",
    }

    file { $wrapper:
      ensure  => link,
      target  => "${basedir}/conf/wrapper.conf",
    }

    file { "${basedir}/conf/maestro_agent.json":
      ensure  => link,
      target  => "${agent_user_home}/conf/maestro_agent.json",
      require => File["${agent_user_home}/conf"],
    }

    file { 'maestro-agent':
      path    => "${basedir}/bin/maestro_agent",
      owner   => $agent_user,
      group   => $agent_group,
      mode    => '0755',
      content => template('maestro/agent/maestro-agent.erb'),
    }
  }

}
