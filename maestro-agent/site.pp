node 'default' {

  include maestro::params

  class { 'maestro_nodes::agent::rvm': }
  class { 'maestro::agent': }
}
