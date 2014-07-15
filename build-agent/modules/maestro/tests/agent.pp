import 'common.pp'

# Agent
class { 'maestro::agent':
  rmi_server_hostname => "10.42.42.50",
}
Package['java'] -> Service['maestro-agent']

# Firewall rule to open up JMX port on our vagrant box
firewall { '900 enable jmx':
  action => accept,
  dport => $maestro::agent::jmxport,
  proto => "tcp",
}
