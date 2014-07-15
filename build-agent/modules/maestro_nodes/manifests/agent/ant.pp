class maestro_nodes::agent::ant(
  $agent_user = $maestro::params::agent_user,
  $agent_group = $maestro::params::agent_group,
  $agent_user_home = $maestro::params::agent_user_home) inherits maestro::params {

  # Ant
  class { '::ant': }
  class { '::ant::ivy': }
  class { '::ant::tasks::maven': }
  class { '::ant::tasks::sonar': }
  file { 'ant.xml':
    path    => "${agent_user_home}/ant.xml",
    owner   => $agent_user,
    group   => $agent_group,
    mode    => 755,
    content => template("maestro_nodes/ant.xml.erb")
  }

}
