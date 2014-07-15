class maestro::maestro::package::tarball(
  $repo,
  $version,
  $base_version,
  $srcdir = $maestro::params::srcdir,
  $homedir,
  $basedir) inherits maestro::params {

  $installdir = $maestro::maestro::installdir

  include wget

  wget::fetch { 'fetch-maestro':
    user        => $repo['username'],
    password    => $repo['password'],
    source      => "${repo['url']}/com/maestrodev/maestro/maestro-jetty/${base_version}/maestro-jetty-${version}-bin.tar.gz",
    destination => "${srcdir}/maestro-jetty-${version}-bin.tar.gz",
    require     => File[$srcdir],
  } ->
  exec {"rm -rf ${installdir}/maestro-${base_version}":
    unless => "egrep \"^${version}$\" $srcdir/maestro-jetty.version",
  } ->
  exec { 'unpack-maestro':
    command => "tar zxvf ${srcdir}/maestro-jetty-${version}-bin.tar.gz",
    creates => "${installdir}/maestro-${base_version}",
    cwd     => $installdir,
  } ->
  exec { "chown -R ${maestro::params::user} ${installdir}/maestro-${base_version}":
    require => User[$maestro::params::user],
  } ->
  file { "${installdir}/maestro-${base_version}/bin":
    mode    => '0755',
    recurse => true,
  } ->
  file { $homedir:
    ensure => link,
    target => "${installdir}/maestro-${base_version}"
  } ->
  file { "${srcdir}/maestro-jetty.version":
    content => "${version}\n",
  } ->
  # Touch the installation package even if current, so that it isn't deleted
  exec { "touch $srcdir/maestro-jetty-${version}-bin.tar.gz":
  } ->
  tidy { 'tidy-maestro':
    age     => '1d',
    matches => 'maestro-jetty-*',
    recurse => true,
    path    => $srcdir,
  }


}
