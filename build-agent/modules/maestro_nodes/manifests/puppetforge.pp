class maestro_nodes::puppetforge(
  $forge = 'https://forge.puppetlabs.com',
  $username = undef,
  $password = undef) inherits maestro::params {

  if $username != undef {

    file { "${maestro::params::agent_user_home}/.puppetforge.yml":
      owner   => $maestro::params::agent_user,
      mode    => '0600',
      content => template('maestro_nodes/puppetforge.yml.erb'),
    }

  }
}
