# database configuration for a local postgresql server
class maestro_nodes::database(
  $password = $maestro::params::db_password,
  $repo_url = 'https://repo.maestrodev.com/archiva/repository/all') inherits maestro::params {
  $maestro_jdbc = {
    url      => 'jdbc:postgresql://localhost/maestro',
    driver   => 'org.postgresql.Driver',
    username => $maestro::params::db_username,
    password => $password,
  }
  $sonar_jdbc = {
    url => 'jdbc:postgresql://localhost/sonar',
    driver_class_name => 'org.postgresql.Driver',
    validation_query => 'values(1)',        
    username => $maestro::params::db_username,
    password => $password,
  }
  $continuum_jdbc = {
    databaseName => 'maestro',
    dataSource   => 'org.postgresql.ds.PGPoolingDataSource',
    username     => $maestro::params::db_username,
    password     => $password,
  }

  $jdbc_driver_url = "${repo_url}/postgresql/postgresql/8.4-702.jdbc3/postgresql-8.4-702.jdbc3.jar"

  # for easier parameter passing
  $database = {
    maestro_jdbc    => $maestro_jdbc,
    sonar_jdbc      => $sonar_jdbc,
    continuum_jdbc  => $continuum_jdbc,
    jdbc_driver_url => $jdbc_driver_url,
  }
}
