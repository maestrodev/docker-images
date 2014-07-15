class maestro::test::remote-control(
  $repo = $maestro::params::repo,
  $version = '1.0.8.2',
  $master_host = 'localhost' ) inherits maestro::params {

  $firefox_version = '10'
  $selenium_environment = "Firefox ${firefox_version} on Linux, Firefox ${firefox_version} on Linux, Firefox ${firefox_version} on Linux"
  $installdir = '/usr/local/maestro-test-remote-control'
  $user = $maestro::params::user
  $group = $maestro::params::group

  wget::fetch { 'fetch-test-remote-control':
    user        => $repo['username'],
    password    => $repo['password'],
    source      => "${repo['url']}/com/maestrodev/maestro/test/rpm/maestro-test-remote-control/${version}/maestro-test-remote-control-${version}.rpm",
    destination => "/tmp/maestro-test-remote-control-${version}.rpm",
  } ->

  package { 'maestro-test-remote-control':
    ensure   => latest,
    provider => rpm,
    source   => "file:///tmp/maestro-test-remote-control-${version}.rpm",
  } ->

  file { '/var/maestro-test-remote-control/conf/wrapper.conf':
    owner   => $user,
    group   => $group,
    mode    => '0644',
    content => template('maestro/test/remote-control-wrapper.erb'),
  } ->

  # Quick and dirty patch to upgrade selenium to 2.20.0 keeping our old RPM
  file { "${installdir}/lib/selenium-server-1.0.3-standalone.jar":
    ensure => absent,
  } ->
  wget::fetch { 'fetch-selenium' :
    source      => 'http://selenium.googlecode.com/files/selenium-server-standalone-2.20.0.jar',
    destination => "${installdir}/lib/selenium-server-standalone-2.20.0.jar",
  }

  # delete the 32 bit wrapper if running in 64 bits or startup will fail
  if $::architecture == 'x86_64' {
    file { "${installdir}/bin/wrapper-linux-x86-32":
      ensure  => absent,
      require => Package['maestro-test-remote-control'],
    } ->
    file { "${installdir}/lib/libwrapper-linux-x86-32.so":
      ensure  => absent,
      notify  => Service['maestro-test-remote-control'],
    }
  }

  class { 'maestro::test::dependencies': } ->

  exec { '/usr/bin/xhost +':
    alias       => 'xhost',
    environment => 'DISPLAY=:0.0',
    user        => $user,
    unless      => '/bin/ps -fea | grep Xvfb',
  } ->
  exec { '/usr/bin/Xvfb :0 -screen 0 800x600x16 &':
    alias  => 'start-xvfb',
    unless => '/bin/ps -fea | grep Xvfb | grep -v grep',
  } ->

  service { 'maestro-test-remote-control':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    subscribe  => File['/var/maestro-test-remote-control/conf/wrapper.conf']
  }

}
