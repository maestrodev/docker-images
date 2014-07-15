class maestro_nodes::agent::maven(
  $agent_user = $maestro::params::agent_user,
  $agent_group = $maestro::params::agent_group,
  $agent_user_home = $maestro::params::agent_user_home,
  $maven_properties = undef) inherits maestro::params {


  # Maven
  class { '::maven::maven':
    version => '3.0.4',
  } ->
  maven::settings { $agent_user :
    home                => $agent_user_home,
    user                => $agent_user,
    default_repo_config => $maestro_nodes::repositories::default_repo_config,
    mirrors             => $maestro_nodes::repositories::mirrors,
    servers             => $maestro_nodes::repositories::servers,
    properties          => $maven_properties,
    require             => [Class['maestro_nodes::repositories']],
  }
}
