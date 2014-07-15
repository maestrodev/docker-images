class maestro::maestro::package(
  $type = $maestro::maestro::package_type,
  $repo = $maestro::maestro::repo,
  $version = $maestro::maestro::version,
  $base_version = $maestro::maestro::base_version,
  $srcdir = $maestro::params::srcdir,
  $homedir = $maestro::maestro::homedir,
  $basedir = $maestro::maestro::basedir) inherits maestro::params {

  ensure_resource('file', $srcdir, {'ensure' => 'directory' })

  case $type {
    'tarball': {
      anchor { 'maestro::maestro::package::begin': } -> Class['maestro::maestro::package::tarball'] -> anchor { 'maestro::maestro::package::end': }

      class { 'maestro::maestro::package::tarball':
        repo         => $repo,
        version      => $version,
        base_version => $base_version,
        srcdir       => $srcdir,
        homedir      => $homedir,
        basedir      => $basedir,
      }
    }
    'rpm': {
      anchor { 'maestro::maestro::package::begin': } -> Class['maestro::maestro::package::rpm'] -> anchor { 'maestro::maestro::package::end': }
      class { 'maestro::maestro::package::rpm':
        version => $version,
      }
    }
    default: {
      fail("Invalid Maestro package type: ${type}")
    }
  }

}