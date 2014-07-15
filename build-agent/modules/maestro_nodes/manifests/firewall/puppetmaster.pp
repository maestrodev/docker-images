class maestro_nodes::firewall::puppetmaster {

  firewall { '040 allow puppetmaster':
    proto  => 'tcp',
    port   => [8140],
    action => 'accept',
  }
}