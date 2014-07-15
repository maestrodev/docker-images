class maestro::agent::service {

  case $::osfamily {
    'Darwin': {
      include maestro::agent::service::darwin
    }
    'RedHat', 'Debian': {
      include maestro::agent::service::linux
    }
    'windows': {
      include maestro::agent::service::windows
    }
    default: {
      fail("Unsupported operating system family: ${::osfamily}")
    }
  }

}
