class maestro::agent::package::tarball(
  $repo,
  $base_version,
  $timestamp_version,
  $srcdir = $maestro::params::srcdir,
  $basedir,
  $agent_user,
  $agent_group,
  $agent_user_home) inherits maestro::params {

  include wget

  file { $basedir:
    ensure  => directory,
    owner   => $agent_user,
    group   => $agent_group,
  }

  wget::fetch { 'fetch-agent':
    user        => $repo['username'],
    password    => $repo['password'],
    source      => "${repo['url']}/com/maestrodev/lucee/agent/${base_version}/agent-${timestamp_version}-bin.tar.gz",
    destination => "${srcdir}/agent-${timestamp_version}-bin.tar.gz",
    require     => File[$srcdir],
  } ->
  exec {"rm -rf ${basedir}":
    unless => "egrep \"^${timestamp_version}$\" ${srcdir}/maestro-agent.version",
  } ->
  exec { 'unpack-agent':
    command => "tar zxf ${srcdir}/agent-${timestamp_version}-bin.tar.gz && chown -R ${agent_user}:${agent_group} maestro-agent ${agent_user_home}",
    creates => "${basedir}/lib",
    cwd     => '/usr/local', # TODO use $basedir instead of hardcoded
    notify  => Service['maestro-agent'],
  } ->
  file { "${basedir}/logs":
    ensure  => link,
    target  => "${agent_user_home}/logs",
    owner   => $agent_user,
    group   => $agent_group,
    force   => true,
  }

}
