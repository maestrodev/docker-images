class maestro_nodes::firewall {

  # Purge unmanaged firewall resources
  #
  # This will clear any existing rules, and make sure that only rules
  # defined in puppet exist on the machine
  resources { 'firewall':
    purge => true,
  }

  # ensure purge happens after basic firewall rules are set
  # https://github.com/puppetlabs/puppetlabs-firewall/issues/239#issuecomment-26443579

  class{ ['maestro_nodes::firewall::pre', 'maestro_nodes::firewall::post']:
    before => Resources['firewall'],
  }
}
