class maestro_nodes::macos_agent(
  $stomp_host,
  $repo,
  $version = '1.4.1',
  $user = 'maestrodev',
  $group = 'staff',
  $home = '/Users/maestrodev',
  $agent_name = $::hostname,
  $maxmemory = '128') inherits maestro_nodes::repositories {

  # facts.d folders
  file { "/etc/facts.d":
    ensure  => absent,
    recurse => true,
    force   => true,
  }
  file { "/etc/facter":
    ensure => directory,
  }
  file { "/etc/facter/facts.d":
    ensure => directory,
  }

  include maestro

  class { 'maestro::params':
    user            => $user,
    group           => $group,
    agent_user      => $user,
    agent_group     => $group,
    agent_user_home => $home,
  }

  class { 'maestro::agent':
    package_type   => 'tarball',
    repo           => $repo,
    agent_version  => $version,
    stomp_host     => $stomp_host,
    agent_name     => $agent_name,
    maxmemory      => $maxmemory,
  }

  ## Maven
  maven::settings { $agent_user :
    home                => $home,
    user                => $user,
    default_repo_config => $maestro_nodes::repositories::default_repo_config,
    mirrors             => $maestro_nodes::repositories::mirrors,
    servers             => $maestro_nodes::repositories::servers,
  }

  # Ant
  class { 'ant': }
  class { 'ant::ivy': }
  class { 'ant::tasks::maven': }
  class { 'ant::tasks::sonar': }
  file { "ant.xml":
    path    => "${home}/ant.xml",
    owner   => $user,
    group   => $group,
    mode    => '0755',
    content => template("maestro_nodes/ant.xml.erb")
  }
  
  # server_key for autoconnect and autoactivate
  file { '.maestro':
    ensure  => directory,
    path    => "${home}/.maestro", 
    owner   => $user,
    group   => $group,
    mode    => '0700',
  } ->
  file { 'server.key':
    content => 'server_key',
    path    => "${home}/.maestro/server.key",
    owner   => $user,
    group   => $group,
    mode    => '0600',
  }
 
}
