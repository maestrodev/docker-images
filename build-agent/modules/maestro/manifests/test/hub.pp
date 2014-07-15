class maestro::test::hub(
  $repo = $maestro::params::repo,
  $version = '1.0.8.2',
  $user = 'maestro' ) inherits maestro::params {

  wget::fetch { 'fetch-test-hub':
    user        => $repo['username'],
    password    => $repo['password'],
    source      => "${repo['url']}/com/maestrodev/maestro/test/rpm/maestro-test-hub/${version}/maestro-test-hub-${version}.rpm",
    destination => "/tmp/maestro-test-hub-${version}.rpm",
  } ->
  package { 'maestro-test-hub':
    ensure   => latest,
    provider => rpm,
    source   => "file:///tmp/maestro-test-hub-${version}.rpm",
  }

  if $::architecture == 'x86_64' {
    file { '/usr/local/maestro-test-hub/bin/wrapper-linux-x86-32':
      ensure  => absent,
      require => Package['maestro-test-hub'],
      notify  => Service['maestro-test-hub'],
    }
  }

  exec { "chown -R ${user} /usr/local/maestro-test-hub":
    path    => ['/bin'],
    require => Package['maestro-test-hub'],
  } ->

  file { '/usr/local/maestro-test-hub/conf/grid_configuration.yml' :
    alias  => 'grid_configuration',
    source => 'puppet:///modules/maestro/test/grid_configuration.yml',
  } ->

  service { 'maestro-test-hub':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File['grid_configuration'],
  }

}
