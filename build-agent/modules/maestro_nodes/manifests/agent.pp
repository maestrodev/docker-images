# A Maestro agent node with:
# git, subversion, maven, ant, ivy

class maestro_nodes::agent(
  $repo = $maestro::params::repo,
  $agent_user = $maestro::params::agent_user,
  $agent_group = $maestro::params::agent_group,
  $agent_user_home = $maestro::params::agent_user_home,
  $version   = undef,
  $maxmemory = undef) inherits maestro_nodes::repositories {

  class { 'maestro_nodes::agent::ant': }
  class { 'maestro_nodes::agent::git': }
  class { 'maestro_nodes::agent::maven': }
  class { 'svn': }
  class { 'maestro_nodes::puppetforge': }


  case $::osfamily {
    'RedHat': {
      ensure_packages(['ruby-json']) # needed for facter to output json
    }
    default: {
    }
  }

  class { 'maestro::agent':
    repo          => $repo,
    agent_version => $version,
    maxmemory     => $maxmemory,
  }
  if defined(Package['java']) {
    Package['java'] -> Service['maestro-agent']
  }

  # server_key for autoconnect and autoactivate
  file { '.maestro':
    ensure  => directory,
    path    => "${agent_user_home}/.maestro", 
    owner   => $agent_user,
    group   => $agent_group,
    mode    => 700,
  } ->
  file { 'server.key':
    content => 'server_key',
    path    => "${agent_user_home}/.maestro/server.key",
    owner   => $agent_user,
    group   => $agent_group,
    mode    => 600,
  }

}
