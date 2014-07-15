# This class is used to install and configure the Maestro server.
#
#  Note that admin_password needs to validate against the password rules (letters+numbers by default)
#
# ==Parameters
#
# [repo]  A hash containing the artifact repository URL and credentials.
# [version] The version to install
# [package_type] Selects the type of package to use for the install. Either rpm, or tarball.
# [ldap] A hash containing the LDAP connection parameters. hostname, ssl, port, dn, bind_dn, bind_password, admin_user
# [enabled] Enables/disables the service
# [lucee] Set to true to install lucee locally.
# [admin] the maestro admin user
# [admin_password] the maestro admin user password
# [master_password] the master password
# [db_server_password] DEPRECATED the database server password
# [db_password] DEPRECATED the database user password
# [db_version] DEPRECATED the PostgreSQL version.
# [db_allowed_rules] DEPRECATED an array used to configure PostgreSQL access control.
# [initmemory] configures the initial memory for the JVM running Maestro
# [maxmemory] configures the max memory for the JVM running Maestro
# [permsize] configures the initial permsize for the JVM running Maestro
# [maxpermsize] configures the max permsize for the JVM running Maestro
# [port] the port maestro should be configured to listen on.
# [lucee_url] the URL for the LUCEE API
# [lucee_password] DEPRECATED the lucee user password
# [lucee_username] DEPRECATED the lucee user name
# [jetty_forwarded] set to true to indicate that jetty is being forwarded by a proxy.
# [mail_from] A hash containing the origin information for emails sent by maestro. name, address.
# [enable_jpda] A boolean indicating whether or not we want to enable JPDA
# [jmxport] The port number the JMX server will listen on (default 9001)
# [rmi_server_hostname] The ip address the JMX server will listen on (default $ipaddress)
# [web_config_properties] properties to add the maestro.properties, such as a feature toggles
# [ga_property_id] the google analytics property id
#
class maestro::maestro(
  $repo = $maestro::params::repo,
  $version = 'present',
  $package_type = 'rpm',
  $ldap = {},
  $enabled = undef,
  $lucee = true,
  $metrics_enabled = false,
  $admin = undef, # deprecated
  $admin_password = undef, # deprecated
  $master_password = $maestro_master_password,
  $db_server_password = undef, # deprecated
  $db_password = undef, # deprecated
  $jdbc_maestro = {
    url => "jdbc:postgresql://${maestro::params::db_host}:${maestro::params::db_port}/maestro",
    driver => "org.postgresql.Driver",
    username => $maestro::params::db_username,
  },
  $jdbc_users = {
    url => "jdbc:postgresql://${maestro::params::db_host}:${maestro::params::db_port}/maestro",
    driver => "org.postgresql.Driver",
    username => $maestro::params::db_username,
  },
  $db_version = undef, # deprecated
  $db_allowed_rules = undef, # deprecated
  $initmemory = undef,
  $maxmemory = undef,
  $permsize = undef,
  $maxpermsize = undef,
  $port = '8080',
  $agent_auto_activate = false,
  $enable_jpda = false,
  $jmxport = '9001',
  $rmi_server_hostname = 'localhost',
  $lucee_url = 'http://localhost:8080/lucee/api/v0/',
  $lucee_password = undef, # deprecated
  $lucee_username = undef, # deprecated
  $jetty_forwarded = $::jetty_forwarded,
  $maestro_context_path = "/",
  $lucee_context_path = "/lucee",
  $mail_from = {
    name    => 'Maestro',
    address => 'info@maestrodev.com'
  },
  $web_config_properties = {},
  $ga_property_id = '',
  $logging_level = $maestro::params::logging_level) inherits maestro::params {

  $installdir = '/usr/local'
  $basedir = $maestro::params::user_home
  $homedir = '/usr/local/maestro'


  File {
    owner => $maestro::params::user,
    group => $maestro::params::group,
  }

  # Deprecate a number of variables moved to params
  if $enabled != undef {
    warning("maestro::maestro::enabled is deprecated and ignored, use maestro::params::enabled")
  }
  if $db_version != undef {
    warning("maestro::maestro::db_version is deprecated, use maestro::params::db_version")
  }
  if $db_server_password != undef {
    warning("maestro::maestro::db_server_password is deprecated, use maestro::params::db_server_password")
  }
  if $db_password != undef {
    warning("maestro::maestro::db_password is deprecated, use maestro::params::db_password")
  }
  if $db_allowed_rules != undef {
    warning("maestro::maestro::db_allowed_rules is deprecated, use maestro::params::db_allowed_rules")
  }
  if $lucee_username != undef {
    warning("maestro::maestro::lucee_username is deprecated, use maestro::params::lucee_username")
  }
  if $lucee_password != undef {
    warning("maestro::maestro::lucee_password is deprecated, use maestro::params::lucee_password")
  }
  if $admin != undef {
    warning("maestro::maestro::admin is deprecated, use maestro::params::admin_username")
  }
  if $admin_password != undef {
    warning("maestro::maestro::admin_password is deprecated, use maestro::params::admin_password")
  }

  # Create user and group

  if ! defined(User[$maestro::params::user]) {
    user { $user:
      ensure     => present,
      home       => $maestro::params::user_home,
      managehome => true,
      shell      => '/bin/bash',
      system     => true,
      gid        => $maestro::params::group,
      require    => Group[$maestro::params::group],
    }
  }

  if ! defined(Group[$maestro::params::group]) {
    group { $maestro::params::group:
      ensure => present,
      system => true,
    }
  }


  # Create the basedir. Where config and logs belong for this
  # particular maestro instance.

  # not needed in Maestro 4.18.0+ RPM
  if ($maestro::maestro::package_type == 'tarball') or (versioncmp($maestro::maestro::version, '4.18.0') < 0) {
    file { $basedir:
      ensure => directory,
    } ->
    file { "${basedir}/conf":
      ensure => directory,
    } ->
    file { "${basedir}/logs":
      ensure => directory,
    } ->
    file { "${basedir}/tmp":
      ensure => directory,
    }
  }

  $base_version = snapshotbaseversion($version)

  if $lucee {
    # For maestro versions older than 4.12.0 we need some more packages
    if versioncmp($version, '4.12.0') < 0 {
      ensure_packages(['libxslt-devel', 'libxml2-devel'])
      Package['libxslt-devel'] -> Class['maestro::lucee']
      Package['libxml2-devel'] -> Class['maestro::lucee']
    }

    class { 'maestro::lucee':
      config_dir          => "${basedir}/conf",
      agent_auto_activate => $agent_auto_activate,
      password            => $db_password,
      before              => Service['maestro'],
      metrics_enabled     => $metrics_enabled,
      lucee_username      => $lucee_username ? {undef => undef, default => $lucee_username},
      lucee_password      => $lucee_password ? {undef => undef, default => $lucee_password},
    }

    # plugin folder
    file { "${user_home}/.maestro" :
      ensure  => directory,
      require => Anchor['maestro::maestro::package::end'],
    } ->
    file { "${user_home}/.maestro/plugins" :
      ensure => directory,
    }
  }

  class { 'maestro::maestro::db':
    version         => $db_version ? {undef => undef, default => $db_version},
    password        => $db_server_password ? {undef => undef, default => $db_server_password},
    db_password     => $db_password ? {undef => undef, default => $db_password},
    allowed_rules   => $db_allowed_rules ? {undef => undef, default => $db_allowed_rules},
  } ->
  class { 'maestro::maestro::package': } ->
  class { 'maestro::maestro::securityconfig': } ->
  class { 'maestro::maestro::config':
    db_version         => $db_version ? {undef => undef, default => $db_version},
    db_server_password => $db_server_password ? {undef => undef, default => $db_server_password},
    db_password        => $db_password ? {undef => undef, default => $db_password},
    db_allowed_rules   => $db_allowed_rules ? {undef => undef, default => $db_allowed_rules},
    admin              => $admin ? {undef => undef, default => $admin},
    admin_password     => $admin_password ? {undef => undef, default => $admin_password},
    lucee_username     => $lucee_username ? {undef => undef, default => $lucee_username},
    lucee_password     => $lucee_password ? {undef => undef, default => $lucee_password},
    logging_level      => $logging_level,
  } ->
  class { 'maestro::maestro::service': }

}
