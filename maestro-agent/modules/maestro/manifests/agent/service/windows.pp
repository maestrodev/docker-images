class maestro::agent::service::windows(
  $enabled     = $maestro::agent::enabled
) {

  # TODO: allow configuration to be separated from installation
  $installdir = $maestro::params::agent_user_home

  exec { "install-windows-agent-service":
    command     => "${installdir}\\bin\\wrapper-windows-x86-32.exe -i ${installdir}\\conf\\wrapper.conf wrapper.ntservice.account=.\\${maestro::params::agent_user} wrapper.ntservice.password=${maestro::params::agent_user_password}",
    refreshonly => true,
  } ->
  service { 'maestro-agent':
    ensure  => $enabled ? { true => running, false => stopped },
    enable  => $enabled,
    require => Anchor['maestro::agent::package::end'],
  }
}

