class maestro::maestro::package::rpm($version) {

  include maestro::yumrepo

  package { 'maestro':
    ensure   => $version,
    before   => File['/etc/sysconfig/maestro'],
  }

}
