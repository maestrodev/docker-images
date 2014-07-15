import '/etc/puppet/modules/maestro_nodes/manifests/nodes/*.pp'


node 'maestro.acme.com' inherits 'parent' {
  yumrepo { 'maestrodev':
    descr    => 'MaestroDev Products EL 6 - $basearch',
    baseurl  => "https://${maestrodev_username}:${maestrodev_password}@yum.maestrodev.com/el/6/\$basearch",
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-maestrodev',
    enabled  => 1,
    gpgcheck => 0,
  }
  class { 'maestro_nodes::maestroserver': }
}

# test that wget requests happen after firewall has been setup
node 'firewall.acme.com' inherits 'parent' {
  class { 'maestro_nodes::maestrofirewall': }
  class { 'maestro_nodes::firewall::puppetmaster': }

  class { 'ant': }
  class { 'ant::ivy': }
  class { 'ant::tasks::maven': }
  class { 'ant::tasks::sonar': }
}

node 'metrics.acme.com' inherits 'parent' {
  include 'maestro_nodes::metrics_repo'
}
