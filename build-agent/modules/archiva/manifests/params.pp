# == Class: archiva::params
#
# This class contains the default parameters for the Archiva puppet module.
#
# === Copyright
#
# Copyright 2012 Maestrodev
#
class archiva::params(
  $version = '1.3.5',
  $user = 'archiva',
  $group = 'archiva',
  $manage_user = true,
  $service = 'archiva',
  $installroot = '/usr/local',
  $home = '/var/local/archiva',
  $apache_mirror = 'http://archive.apache.org/dist',

  # Example:
  # url      => 'http://repo1.maven.org/maven2'
  # username => ''
  # password => ''

  $repo = {  },
  $port = '8080',
  $application_url = 'http://localhost:8080/archiva/',

  # Example:
  # name    => 'Apache Archiva',
  # address => 'archiva@example.com',
  $mail_from = { },

  # Example:
  # hostname      => '',
  # ssl           => true,
  # port          => '636',
  # dn            => '',
  # bind_dn       => '',
  # bind_password => '',
  # admin_user    => 'root',,
  $ldap = { },
  $cookie_path = '',
  $max_upload_size = undef,
  $archiva_jdbc = {
    url      => 'jdbc:derby:/var/local/archiva/data/databases/archiva;create=true',
    driver   => 'org.apache.derby.jdbc.EmbeddedDriver',
    username => 'sa',
    password => ''
  },
  $users_jdbc = {
    url      => 'jdbc:derby:/var/local/archiva/data/databases/users;create=true',
    driver   => 'org.apache.derby.jdbc.EmbeddedDriver',
    username => 'sa',
    password => ''
  },
  $jdbc_driver_url = '',
  $maxmemory = undef,
  $jetty_version = undef,
  $forwarded = false){

}
