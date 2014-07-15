class maestro_nodes::nginxproxy(
  $hostname = $maestro_nodes::nginx::params::hostname,
  $maestro_port = $maestro::maestro::port,
  $ssl = $maestro_nodes::nginx::params::ssl,
  $ssl_cert = $maestro_nodes::nginx::params::ssl_cert,
  $ssl_key = $maestro_nodes::nginx::params::ssl_key,
) inherits maestro_nodes::nginx::params {

  include nginx

  if $ssl == true {
    $port = '443'

    file { '/etc/nginx/conf.d/default.conf':
      ensure => present,
      source => "puppet:///modules/maestro_nodes/nginx/default.conf",
      notify => Service[nginx],
      require => Package[nginx],
    }
  } else {
    $port = '80'

    file { '/etc/nginx/conf.d/default.conf':
      ensure => absent,
      notify => Service[nginx],
      require => Package[nginx],
    }
  }

  nginx::resource::vhost { $hostname:
    ensure => present,
    ssl => $ssl,
    listen_port => $port,
    ssl_cert => $ssl_cert,
    ssl_key => $ssl_key,
    proxy => 'http://maestro_app',
  }

  nginx::resource::upstream { 'maestro_app':
    ensure => present,
    members => ["localhost:$maestro_port"],
  }
}
