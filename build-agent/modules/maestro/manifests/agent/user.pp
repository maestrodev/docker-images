class maestro::agent::user {

  # Note that later pieces assume basedir ends in maestro-agent, would need a
  # different approach

  if ! defined(User[$maestro::params::agent_user]) {

    if ! defined(Group[$maestro::params::agent_group]) {
      group { $maestro::params::agent_group:
        ensure => present,
      }
    }

    if $::operatingsystem == 'Darwin' {
      # User creation is broken in Mountain Lion
      # user { $maestro::params::agent_user:
      #  ensure     => present,
      #  home       => $maestro::params::agent_user_home,
      #  shell      => '/bin/bash',
      #  gid        => $maestro::params::agent_group,
      #  groups     => 'admin',
      #  before     => Class['maestro::agent::package'],
      #}
    } 
    elsif $::operatingsystem == 'windows' {
      user { $maestro::params::agent_user:
        ensure     => present,
        password   => $maestro::params::agent_user_password,
        notify     => Exec['grant-agent-service-permissions'],
      }
      file { 'C:\Windows\Temp\Grant-LogOnAsService.ps1':
        source             => 'puppet:///modules/maestro/agent/Grant-LogOnAsService.ps1',
        source_permissions => ignore,
      } ->
      exec { 'grant-agent-service-permissions':
        command     => "C:\\Windows\\System32\\WindowsPowershell\\v1.0\\powershell.exe -NoProfile -NonInteractive -NoLogo -ExecutionPolicy Bypass -File C:\\Windows\\Temp\\Grant-LogOnAsService.ps1 ${maestro::params::agent_user}",
        refreshonly => true,
      }
    }
    else
    {
      user { $maestro::params::agent_user:
        ensure     => present,
        managehome => true,
        home       => $maestro::params::agent_user_home,
        shell      => '/bin/bash',
        gid        => $maestro::params::agent_group,
        groups     => 'root',
        system     => true,
      }
    }
  }

}
