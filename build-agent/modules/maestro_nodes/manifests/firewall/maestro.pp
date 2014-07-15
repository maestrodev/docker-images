class maestro_nodes::firewall::maestro {

  include maestro_nodes::firewall

  firewall { '020 allow http/https':
    proto  => 'tcp',
    port   => [80,443,8080],
    action => 'accept',
  }
  firewall { '030 allow stomp':
    proto  => 'tcp',
    port   => [61613],
    action => 'accept',
  }
}
