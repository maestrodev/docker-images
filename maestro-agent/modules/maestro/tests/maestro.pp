import 'common.pp'

include activemq
include activemq::stomp

# Maestro
class { 'maestro::maestro':
  admin_password     => "admin1",
  master_password    => "admin1",
  db_server_password => "admin1",
  db_password        => "admin1",
}

Package['java'] -> Service['activemq']
Package['java'] -> Service['maestro']
