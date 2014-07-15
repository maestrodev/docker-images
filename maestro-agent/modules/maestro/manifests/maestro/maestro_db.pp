# create a database and give all permissions to maestro user
define maestro::maestro::maestro_db() {

  include maestro::params

  postgresql::server::database { $name: }

  postgresql::server::database_grant { "maestro db ${name}":
    privilege => 'ALL',
    role      => $maestro::params::db_username,
    db        => $name,
  }
}
