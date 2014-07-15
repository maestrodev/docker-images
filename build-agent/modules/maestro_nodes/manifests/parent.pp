# A typical parent node that can be reused
class maestro_nodes::parent() {

  group { 'puppet':
    ensure => 'present',
  }

  # Java
  include java

  case $::kernel {
   'Linux': {
     file { '/etc/motd':
         content => "Maestro 4\n"
     }     
     
     # NTP client
     class { 'ntp': }
    }
    default: {

    }
  }

  # Need epel for rvm installation and nginx
  stage { 'epel': }
  class { 'epel': stage => 'epel' }
}
