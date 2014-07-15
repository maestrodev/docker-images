class maestro_nodes::nginx::jenkins(
  $jenkins_port = 8181,
  $hostname = $maestro_nodes::nginx::params::hostname,
  $ssl = $maestro_nodes::nginx::params::ssl,
) inherits maestro_nodes::nginx::params {

  nginx::resource::location { 'jenkins_app':
    ensure => present,
    location => '/jenkins/',
    proxy => 'http://jenkins_app',
    vhost => $hostname,
    ssl => $ssl,
    ssl_only => $ssl,
  }

  nginx::resource::upstream { 'jenkins_app':
    ensure => present,
    members => ["localhost:$jenkins_port"],
  }
}
