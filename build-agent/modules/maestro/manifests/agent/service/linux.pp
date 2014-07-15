class maestro::agent::service::linux(
  $enabled     = $maestro::agent::enabled
) {

  # tarballs and older rpms
  if ($maestro::agent::package_type == 'tarball') or (versioncmp($maestro::agent::agent_version, '2.1.0') < 0) {

    file { '/etc/init.d/maestro-agent':
      ensure  => link,
      target  => "${maestro::agent::basedir}/bin/maestro_agent",
      notify  => Service['maestro-agent'],
      require => Anchor['maestro::agent::package::end'],
    }
  }

  service { 'maestro-agent':
    ensure  => $enabled ? { true => running, false => stopped },
    enable  => $enabled,
    require => Anchor['maestro::agent::package::end'],
  }
}
