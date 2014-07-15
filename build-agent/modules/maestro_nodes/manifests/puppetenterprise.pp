class maestro_nodes::puppetenterprise(
  $repo = $maestro::params::repo,
  $stomp_port = 61630) inherits maestro::params {

  $srcdir = '/usr/local/src'
  $unpackdir = "${srcdir}/puppet-enterprise-2.7.1-el-6-x86_64"

  wget::authfetch { 'fetch-pe':
    user        => $repo['username'],
    password    => $repo['password'],
    source      => "${repo['url']}/com/puppetlabs/pe/puppet-enterprise-el-6-x86_64/2.7.1/puppet-enterprise-el-6-x86_64-2.7.1.tar.gz",
    destination => "${srcdir}/puppet-enterprise-el-6-x86_64-2.7.1.tar.gz",
  } ->
  exec { 'unpack-pe':
    command => 'tar -xvf puppet-enterprise-el-6-x86_64-2.7.1.tar.gz',
    cwd     => $srcdir,
    creates => $unpackdir,
  } ->
  file { "${unpackdir}/puppet-enterprise-installer-answers.txt":
    source => 'puppet:///modules/maestro_nodes/puppet-enterprise-installer-answers.txt',
  } ->
  exec { 'install-pe':
    command => "${unpackdir}/puppet-enterprise-installer -a puppet-enterprise-installer-answers.txt",
    cwd     => $unpackdir,
    timeout => 0,
    creates => '/opt/puppet',
  } ->
  file { '/etc/puppetlabs/facter/facts.d/puppet_enterprise_installer.txt':
    content => template('maestro_nodes/puppet_enterprise_installer.txt.erb'),
  } ->
  exec { 'pe-puppet-agent':
    command => '/opt/puppet/bin/puppet agent --test',
    returns => [0, 2],
  }

}