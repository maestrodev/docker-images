# This class is used to install and configure the Apache Ant tool.
#
# ==Parameters
#
# [version]  The Ant version to install.
class ant($version = $ant::params::version) inherits ant::params {
  $srcdir = $ant::params::srcdir

  case $::kernel {
    'Linux': {
      ensure_packages(['tar'])
      Package['tar'] -> Exec['unpack-ant']
    }
  }

  wget::fetch { 'ant':
    source      =>  "http://archive.apache.org/dist/ant/binaries/apache-ant-${version}-bin.tar.gz",
    destination => "${srcdir}/apache-ant-${version}-bin.tar.gz"
  } ->
  exec { 'unpack-ant':
    command => "tar zxvf ${srcdir}/apache-ant-${version}-bin.tar.gz",
    cwd     => '/usr/share/',
    creates => "/usr/share/apache-ant-${version}",
    path    => '/bin/:/usr/bin',
  } ->
  file { '/usr/bin/ant':
    ensure => link,
    target => "/usr/share/apache-ant-${version}/bin/ant",
  }

}