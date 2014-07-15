class maestro_nodes::firewall::post {

  anchor { 'firewall-post':
    require => Anchor['firewall-pre'], # this is kindof duplicated but needed
  } ->

  firewall { "999 drop all other requests":
    proto       => 'all',
    action      => 'drop',
    before      => undef,
  }

}
