class maestro::agent::package::rpm($version) {

  include maestro::yumrepo

  package { 'maestro-agent':
    ensure   => $version,
    before   => [File['/etc/sysconfig/maestro-agent'], File[$maestro::agent::agent_user_home]], # so agent owner is set by puppet afterwards
  }

}
