class maestro_nodes::agentrvm {

  include maestro_nodes::agent

  class { 'maestro_nodes::agent::rvm': }
}
