class activemq::service() inherits activemq::params {

  service { 'activemq':
    name       => 'activemq',
    ensure     => running,
    hasrestart => true,
    hasstatus  => false,
    enable     => true,
    require    => Anchor['activemq::package::end'],
  }
}
