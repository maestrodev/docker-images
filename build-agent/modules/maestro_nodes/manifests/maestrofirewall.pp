class maestro_nodes::maestrofirewall {

  notify { 'maestro_nodes::maestrofirewall is deprecated, use maestro_nodes::firewall::maestro': }

  include maestro_nodes::firewall::maestro

}
