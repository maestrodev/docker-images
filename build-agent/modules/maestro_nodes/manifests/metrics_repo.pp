class maestro_nodes::metrics_repo($statsd_enabled = true) {

  class { 'mongodb':
    enable_10gen => false,
  }

  if $statsd_enabled {
    $statsd_config = { 'mongoHost' => '"localhost"',
      'mongoMax' => 2160
    }
    $backends =   [ 'mongo-statsd-backend' ]

    class { 'nodejs':
    } ->
    file { "/etc/yum.repos.d/nodejs-stable.repo":
      ensure => absent,
    }
    package { 'mongo-statsd-backend':
      ensure   => present,
      provider => npm,
    } ->
    class { 'statsd':
      ensure   => '0.4.0',
      backends => $backends,
      config   => $statsd_config,
    }
  }
}
