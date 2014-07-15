# Sonar server using postgres database
class maestro_nodes::sonarserver(
  $port = 8083,
  $db_password = $maestro_nodes::database::password) inherits maestro_nodes::database {

  postgresql::server::db{ 'sonar':
    user      => 'maestro',
    password  => $db_password,
    require   => [Class['postgresql::server']],
  } ->
  class { sonar:
    port => $port,
    jdbc => $maestro_nodes::database::sonar_jdbc,
  }
}
