# Maestro repositories
class maestro_nodes::repositories( 
  $host = 'localhost', # deprecated, use url
  $port = '8082', # deprecated, use url
  $download_url = undef,
  $deploy_url = undef,
  $user = $maestro::params::admin_username,
  $password = $maestro::params::admin_password,
  $default_repo_config = {},
  $maven_mirrors = undef,
  $maven_servers = undef ) inherits maestro::params {

  $download_repo_url = $download_url ? {
    undef   => "http://${host}:${port}/archiva/repository/all",
    default => $download_url,
  }
  $deploy_repo_url = $deploy_url ? {
    undef   => "http://${host}:${port}/archiva/repository/snapshots",
    default => $deploy_url,
  }
  
  # download from here
  $repo = {
    id       => 'maestro-mirror',
    username => $user,
    password => $password,
    url      => $download_repo_url,
    mirrorof => 'external:*',
  }

  # deploy here
  $maestro_repo = {
    id       => 'maestro-deploy',
    username => $user,
    password => $password,
    url      => $deploy_repo_url,
  }

  $mirrors = $maven_mirrors ? {
    undef   => [$repo],
    default => $maven_mirrors,
  }

  $servers = $maven_servers ? {
    undef   => [$repo, $maestro_repo],
    default => $maven_servers,
  }

}
