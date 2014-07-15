class activemq::package::tarball(
  $version = '5.8.0',
  $home = $activemq::home,
  $user = $activemq::user,
  $group = $activemq::group,
  $system_user = $activemq::system_user) {

  # wget from https://github.com/maestrodev/puppet-wget
  include wget


  if ! defined (User[$user]) {
    user { $user:
      ensure     => present,
      home       => "${home}/${user}",
      managehome => false,
      system     => $system_user,
    }
  }

  if ! defined (Group[$group]) {
    group { $group:
      ensure  => present,
      system  => $system_user,
    }
  }

  wget::fetch { "activemq_download":
    source => "${activemq::apache_mirror}/activemq/apache-activemq/${version}/apache-activemq-${version}-bin.tar.gz",
    destination => "/usr/local/src/apache-activemq-${version}-bin.tar.gz",
    require => [User[$user],Group[$group]],
  } ->
  exec { "activemq_untar":
    command => "tar xf /usr/local/src/apache-activemq-${version}-bin.tar.gz && chown -R ${user}:${group} ${home}/apache-activemq-${version}",
    cwd     => $home,
    creates => "${home}/apache-activemq-${activemq::version}",
    path    => ["/bin"],
    before  => File["${home}/activemq"],
  }

  file { "${home}/activemq":
    owner  => $user,
    group  => $group,
    ensure  => "$home/apache-activemq-$version",
    require => Exec["activemq_untar"],
  } ->
  file { "/etc/activemq":
    ensure  => "${home}/activemq/conf",
    require => File["${home}/activemq"],
  } ->
  file { "/var/log/activemq":
    ensure  => "${home}/activemq/data",
    require => File["${home}/activemq"],
  } ->
  file { "${home}/activemq/bin/linux":
    ensure  => "${home}/activemq/bin/linux-x86-64",
    require => File["${home}/activemq"],
  } ->
  file { "/var/run/activemq":
    ensure  => directory,
    owner   => $user,
    group   => $group,
    mode    => 755,
  } ->
  file { "/etc/init.d/activemq":
    owner   => root,
    group   => root,
    mode    => 755,
    content => template("activemq/activemq-init.d.erb"),
  }

  file { "wrapper.conf":
    path    => $activemq::wrapper,
    owner   => $user,
    group   => $group,
    mode    => 644,
    content => template("activemq/wrapper.conf.erb"),
    require => [File["${home}/activemq"],File["/etc/init.d/activemq"]],
    notify  => Service['activemq'],
  }
}
