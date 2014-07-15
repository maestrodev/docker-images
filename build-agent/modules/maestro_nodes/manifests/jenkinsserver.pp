# A jenkins server configured with git plugin and configured to use the
# Archiva repository for Maven builds
class maestro_nodes::jenkinsserver(
  $user = undef,
  $group = undef,
  $version = undef,
  $port = undef,
  $prefix = undef,
  $git_plugin_version = undef,
  $git_client_plugin_version = undef ) inherits maestro_nodes::repositories {

  if $version != undef {
    warning("maestro_nodes::jenkinsserver::version is deprecated, use hiera on jenkins class")
  }
  if $port != undef {
    warning("maestro_nodes::jenkinsserver::port is deprecated, use hiera on jenkins class")
  }

  if $user != undef {
    warning("maestro_nodes::jenkinsserver::user is ignored")
  }
  if $group != undef {
    warning("maestro_nodes::jenkinsserver::group is ignored")
  }
  if $prefix != undef {
    warning("maestro_nodes::jenkinsserver::prefix is ignored")
  }
  if $git_plugin_version != undef {
    warning("maestro_nodes::jenkinsserver::git_plugin_version is ignored, use jenkins::plugin_hash")
  }
  if $git_client_plugin_version != undef {
    warning("maestro_nodes::jenkinsserver::git_client_plugin_version is ignored, use jenkins::plugin_hash")
  }

  if $port != undef {
    $config_hash = { 'HTTP_PORT' => { 'value' => $port } }
  } else {
    $config_hash = undef
  }

  class { 'jenkins' :
    config_hash => $config_hash,
    version     => $version,
  }
  if defined(Package['java']) {
    Package['java'] -> Service['jenkins']
  }

  maven::settings { 'jenkins' :
    home                => '/var/lib/jenkins',
    user                => 'jenkins',
    default_repo_config => $maestro_nodes::repositories::default_repo_config,
    mirrors             => $maestro_nodes::repositories::mirrors,
    servers             => $maestro_nodes::repositories::servers,
    require             => Package['jenkins'],
  }

}
