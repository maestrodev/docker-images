class activemq::package::rpm(
  $version = 'present') {

  package { 'activemq':
    ensure => $version,
  }

}
