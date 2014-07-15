class maestro_nodes::agent::jenkins() inherits maestro::params {

  class { '::jenkins::slave':
    manage_slave_user => false,
    slave_user        => $maestro::params::agent_user,
    slave_home        => $maestro::params::agent_user_home,
  }
}
