class maestro::maestro::db(
  $version             = $maestro::params::db_version,
  $password            = $maestro::params::db_server_password,
  $db_password         = $maestro::params::db_password,
  $allowed_rules       = $maestro::params::db_allowed_rules,
  $manage_package_repo = true,
  $enabled             = true) inherits maestro::params {

  if !($version == '' or $version == undef) {
    class { 'postgresql::globals':
      version             => $version,
      manage_package_repo => $manage_package_repo,
    }
  }
  class { 'postgresql::server':
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '0.0.0.0/0',
    listen_addresses           => '*',
    manage_firewall            => false,
    postgres_password          => $password,
    ipv4acls                   => $allowed_rules,
  }


  if $enabled {

    postgresql::server::role { $maestro::params::db_username:
      password_hash => postgresql_password($maestro::params::db_username, $db_password),
    }

    maestro::maestro::maestro_db { 'maestro': }
    maestro::maestro::maestro_db { 'luceedb': }
    maestro::maestro::maestro_db { 'users': }
  }
  else {
    service { 'postgresql':
      ensure    => stopped,
      enable    => false,
      hasstatus => true,
    }
  }

}
