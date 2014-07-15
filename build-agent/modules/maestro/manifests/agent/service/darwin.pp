class maestro::agent::service::darwin(
  $enabled = $maestro::agent::enabled
) {

  $basedir = $maestro::agent::basedir
  $ensure_service = $enabled ? { true => running, false => stopped, }

  file { '/Library/LaunchDaemons/com.maestrodev.agent.plist':
    ensure  => present,
    content => template('maestro/agent/com.maestrodev.agent.plist.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => 'wheel',
    notify  => Service['maestro-agent'],
  } ->
  service { 'maestro-agent':
    ensure     => $ensure_service,
    name       => 'com.maestrodev.agent',
    enable     => $enabled,
    hasstatus  => true,
    hasrestart => true,
    provider   => launchd,
    require    => Anchor['maestro::agent::package::end'],
  }
}
