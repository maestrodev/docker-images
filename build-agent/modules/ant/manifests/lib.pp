# This defined type is used to install and configure the Apache Ant libraries.
#
# ==Parameters
#
# [version]    The version of the library to install.
# [source_url] The location of the ant library jar file.
define ant::lib($version, $source_url) {

  include ant::params

  wget::fetch { "${name}-antlib":
    source      => $source_url,
    destination => "/usr/share/apache-ant-${ant::params::version}/lib/${name}-$version.jar",
    require     => Class['ant'],
  }

}
