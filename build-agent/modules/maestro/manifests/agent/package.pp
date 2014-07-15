class maestro::agent::package(
  $type = $maestro::agent::package_type,
  $repo = $maestro::agent::repo,
  $version = $maestro::agent::agent_version,
  $srcdir = $maestro::params::srcdir,
  $basedir = $maestro::agent::basedir,
  $agent_user = $maestro::agent::agent_user,
  $agent_group = $maestro::agent::agent_group,
  $agent_user_home = $maestro::agent::agent_user_home) inherits maestro::params {

  $timestamp_version = $version # version is a release
  $base_version = snapshotbaseversion($version)

  if $type == 'tarball' or $type == 'rpm' {
    # in RPM agents >= 2.1.0 this is only needed to ensure the owner and group
    file { '/var/local':
      ensure  => directory,
    } ->
    file { [$agent_user_home,"${agent_user_home}/logs","${agent_user_home}/conf","${agent_user_home}/tmp"]:
      ensure  => directory,
      owner   => $agent_user,
      group   => $agent_group,
    }
  }

  case $type {

    'tarball': {
      anchor { 'maestro::agent::package::begin': } -> Class['maestro::agent::package::tarball'] -> anchor { 'maestro::agent::package::end': }

      ensure_resource('file', $srcdir, {'ensure' => 'directory' })

      class { 'maestro::agent::package::tarball':
        repo              => $repo,
        timestamp_version => $timestamp_version,
        base_version      => $base_version,
        srcdir            => $srcdir,
        basedir           => $basedir,
        agent_user        => $agent_user,
        agent_group       => $agent_group,
        agent_user_home   => $agent_user_home,
      }
      contain 'maestro::agent::package::tarball'
    }
    'rpm': {
      anchor { 'maestro::agent::package::begin': } -> Class['maestro::agent::package::rpm'] -> anchor { 'maestro::agent::package::end': }

      class { 'maestro::agent::package::rpm':
        version => $version,
      }
      contain 'maestro::agent::package::rpm'
    }
    'windows': {
      anchor { 'maestro::agent::package::begin': } -> Class['maestro::agent::package::windows'] -> anchor { 'maestro::agent::package::end': }

      class { 'maestro::agent::package::windows': }
      contain 'maestro::agent::package::windows'
    }
    default: {
      fail("Invalid Maestro package type: ${type}")
    }
  }

}
