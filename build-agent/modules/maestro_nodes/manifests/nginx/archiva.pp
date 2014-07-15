class maestro_nodes::nginx::archiva(
  $archiva_port = $maestro_nodes::archivaserver::port,
  $hostname = $maestro_nodes::nginx::params::hostname,
  $ssl = $maestro_nodes::nginx::params::ssl,
) inherits maestro_nodes::nginx::params {

  nginx::resource::location { 'archiva_app':
    ensure => present,
    location => '/archiva/',
    proxy => 'http://archiva_app',
    vhost => $hostname,
    ssl => $ssl,
    ssl_only => $ssl,
  }

  nginx::resource::upstream { 'archiva_app':
    ensure => present,
    members => ["localhost:$archiva_port"],
  }
}
