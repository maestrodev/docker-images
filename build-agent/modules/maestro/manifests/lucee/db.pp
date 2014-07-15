# "database": {
#   "server": "postgres",
#   "host": "localhost",
#   "port": 5432,
#   "user": "<%= db_username %>",
#   "pass": "<%= db_password %>",
#   "database_name": "<%= db_name %>"
# },
class maestro::lucee::db(
  $username = $maestro::params::db_username,
  $password = $maestro::params::db_password,
  $type = 'postgres',
  $host = $maestro::params::db_host,
  $port = $maestro::params::db_port,
  $database = 'luceedb') inherits maestro::params {
}
