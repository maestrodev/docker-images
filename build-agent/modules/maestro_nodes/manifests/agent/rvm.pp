class maestro_nodes::agent::rvm(
  $agent_user = $maestro::params::agent_user) inherits maestro::params {

  # install rubies from binaries
  Rvm_system_ruby {
    build_opts => ['--binary'],
  }

  # ensure rvm doesn't timeout finding binary rubies
  class { '::rvm::rvmrc':
    max_time_flag => 20,
  }
  class { '::rvm': }

  ::rvm::system_user { $agent_user: }

  if defined(Package['jenkins']) {
    ::rvm::system_user { 'jenkins':
      require => Package['jenkins'],
    }
  }

  class { 'maestro_nodes::rubygems': }

}
