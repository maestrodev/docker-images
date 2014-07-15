# == Class: archiva
#
# This class is used to download, install and configure Apache Archiva.
#
# === Parameters
#
# [version] the archiva version to download and install.
# [user] the user used to own/run archiva.
# [group] the group used to own/run archiva.
# [manage_user] set to true to create users and groups.
# [service] the name of the archiva service.
# [installroot] the root of the install directory (/usr/local).
# [home] the user home.
# [apache_mirror] the base URL of the Apache mirror site.
# [repo] a hash containing parameters for the repository where the distribution might be found. url, username, password.
# [application_url] the URL where the application can be reached.
# [port] the port Archiva should be listening on.
# [mail_from] a hash email configuration. Should contain name and address parameters.
# [ldap] a hash containing LDAP configuration. May contain hostname, ssl, port, dn. bind_dn, bind_password, admin_user.
# [cookie_path] the security cookie path
# [max_upload_size] the maximum upload size
# [archiva_jdbc] a hash containing JDBC parameters for the archiva DB. Not used in newer versions of Archiva. Should contain url, driver, username, password.
# [users_jdbc] a hash containing JDBC parameters for the users DB. Should contain url, driver, username, password.
# [jdbc_driver_url] the URL where the JDBC driver can be found and downloaded from.
# [maxmemory] the maximum memory server configuration.
# [jetty_version] the version of Jetty to use.
# [forwarded] set to true if jetty is behind a reverse proxy.
#
# === Examples
#
# $database =  {
#   url      => 'jdbc:postgresql://localhost/archiva',
#   driver   => 'org.postgresql.Driver',
#   username => 'archiva',
#   password => 'archiva',
# }
#
# $ldap = {
#   hostname      => 'ldap.example.com',
#   ssl           => true,
#   port          => '636',
#   dn            => 'o=example',
#   bind_dn       => "cn=admin,ou=system,o=example",
#   bind_password => "admin123",
#   admin_user    => "sysadmin",
#   guest_user    => "guest"
# }
#
# class { archiva:
#   ldap => $ldap,
#   archiva_jdbc => $database,
#   users_jdbc => $database,
#   $jdbc_driver_url => 'http://jdbc.postgresql.org/download/postgresql-9.2-1001.jdbc4.jar'
# }
#
# === Copyright
#
# Copyright 2012 Maestrodev
#
class archiva(
  $version = $archiva::params::version,
  $user = $archiva::params::user,
  $group = $archiva::params::group,
  $manage_user = $archiva::params::manage_user,
  $service = $archiva::params::service,
  $installroot = $archiva::params::installroot,
  $home = $archiva::params::home,
  $apache_mirror = $archiva::params::apache_mirror,
  $repo = $archiva::params::repo,
  $application_url = $archiva::params::application_url,
  $port = $archiva::params::port,  
  $mail_from = $archiva::params::mail_from,
  $ldap = $archiva::params::ldap,
  $cookie_path = $archiva::params::cookie_path,
  $max_upload_size = $archiva::params::max_upload_size,
  $archiva_jdbc = $archiva::params::archiva_jdbc,
  $users_jdbc = $archiva::params::users_jdbc,
  $jdbc_driver_url = $archiva::params::jdbc_driver_url,
  $maxmemory = $archiva::params::maxmemory,
  $jetty_version = $archiva::params::jetty_version,
  $forwarded = $archiva::params::forwarded) inherits archiva::params {

  # wget from https://github.com/maestrodev/puppet-wget
  include wget

  if $jetty_version == undef {
    $jetty_version_real = $version ? {
      /^(1\.[23]|1\.4-M1)/ => 6,
      /^1\.4/              => 7,
      /^2\.0/              => 8,
      default              => 8,
    }
  }
  else {
    $jetty_version_real = $jetty_version
  }

  File { owner => $user, group => $group, mode => '0644' }

  Exec { path => '/bin' }

  $baseversion = snapshotbaseversion($version)
  $installdir = "${installroot}/apache-archiva-${baseversion}"
  $archive = "/usr/local/src/apache-archiva-${version}-bin.tar.gz"

  # Derby specifics
  if $archiva_jdbc['driver'] == 'org.apache.derby.jdbc.EmbeddedDriver' {
    $archiva_u = regsubst($archiva_jdbc['url'],';.*$', '')
    $archiva_jdbc['shutdown_url'] = "${archiva_u};shutdown=true"
  }

  if $users_jdbc['driver'] == 'org.apache.derby.jdbc.EmbeddedDriver' {
    $users_u = regsubst($users_jdbc['url'], ';.*$', '')
    $users_jdbc['shutdown_url'] = "${users_u};shutdown=true"
  }

  if $manage_user {
    # check for undef, so we don't have to explicitly define the fact in specs
    if (($::puppetversion == undef) or ($::puppetversion >= '2.7.0')) {
      user { $user:
        ensure     => present,
        home       => $home,
        managehome => false,
        system     => true,
      }
    } else {
      user { $user:
        ensure     => present,
        home       => $home,
        managehome => false,
      }
    }

    group { $group:
      ensure  => present,
      require => User[$user],
    }
  }
  if "${repo['url']}" != '' {
    wget::fetch { 'archiva_download':
      source      => "${repo['url']}/org/apache/archiva/archiva-jetty/$baseversion/archiva-jetty-${version}-bin.tar.gz",
      destination => $archive,
      user        => $repo['username'] ? { '' => undef, default => $repo['username'] },
      password    => $repo['password'] ? { '' => undef, default => $repo['password'] },
      notify      => Exec['archiva_untar'],
    }
  } else {
    if versioncmp($version, '1.3.5') >= 0 and $version != '1.4-M1' {
      $mirror_url = "${apache_mirror}/archiva/${version}/binaries/apache-archiva-${version}-bin.tar.gz"
    } else {
      $mirror_url = "${apache_mirror}/archiva/binaries/apache-archiva-${version}-bin.tar.gz"
    }
    wget::fetch { 'archiva_download':
      source      => $mirror_url,
      destination => $archive,
      notify      => Exec['archiva_untar'],
    }
  }
  exec { 'archiva_untar':
    command => "tar zxf ${archive}",
    cwd     => $installroot,
    creates => $installdir,
    notify  => Service[$service],
  } ->
  file { "${installroot}/${service}":
    ensure  => link,
    target  => $installdir,
  }
  if $::architecture == 'x86_64' or $::architecture == 'amd64' {
    file { "${installdir}/bin/wrapper-linux-x86-32":
      ensure  => absent,
      require => Exec['archiva_untar'],
    }
    file { "${installdir}/lib/libwrapper-linux-x86-32.so":
      ensure  => absent,
      require => Exec['archiva_untar'],
    }
  }
  if $jdbc_driver_url != '' {
    $filename = regsubst($jdbc_driver_url,'^.*/', '')
    wget::fetch { 'archiva_jdbc_driver_download':
      source      => $jdbc_driver_url,
      destination => "${installdir}/lib/${filename}",
      require     => Exec['archiva_untar'],
    } ->
    file { "${home}/conf/wrapper.conf":
      ensure  => "${installdir}/conf/wrapper.conf",
    } ->
    exec { 'archiva_jdbc_driver_append':
      command => "sed -i 's/derby.*$/${filename}/' ${installdir}/conf/wrapper.conf",
      unless  => "grep '${filename}' ${installdir}/conf/wrapper.conf",
      notify  => Service[$service],
      require => [File["${home}/conf"],Exec['archiva_untar']],
    }
  } else {
    file { "${home}/conf/wrapper.conf":
      ensure  => link,
      target  => "${installdir}/conf/wrapper.conf",
    }
  }
  if $version == '1.4-M2' {
    exec { 'fix_tmpdir_14M2':
      command => "sed -i 's#java.io.tmpdir=./temp#java.io.tmpdir=%ARCHIVA_BASE%/tmp#' ${home}/conf/wrapper.conf",
      unless  => "grep 'java.io.tmpdir=%ARCHIVA_BASE%/tmp' $home/conf/wrapper.conf",
      notify  => Service[$service],
      require => File["$home/conf/wrapper.conf"],
    }
  }

  file { $home:
    ensure => directory,
  } ->
  file { "${home}/temp":
    ensure => directory,
  } ->
  file { "${home}/tmp":
    ensure => directory,
  } ->
  file { "${home}/logs":
    ensure => directory,
  } ->
  file { "${home}/conf":
    ensure  => directory,
    require => Exec['archiva_untar'],
  } ->
  file { "${home}/conf/shared.xml":
    ensure => present,
    source => "${installdir}/conf/shared.xml",
  } ->
  file { "${home}/conf/jetty.xml":
    ensure  => present,
    content => template("archiva/jetty${jetty_version_real}.xml.erb"),
    notify  => Service[$service],
  } ->
  file { "${home}/conf/security.properties":
    ensure  => present,
    content => template('archiva/security.properties.erb'),
    notify  => Service[$service],
  } ->
  file { '/etc/profile.d/archiva.sh':
    owner   => 'root',
    mode    => '0755',
    content => "export ARCHIVA_BASE=${home}\n",
  } ->
  file { "/etc/init.d/${service}":
    owner   => 'root',
    mode    => '0755',
    content => template('archiva/archiva.erb'),
  } ->
  service { $service:
    ensure     => running,
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }

  if $maxmemory != undef {
    # Adjust wrapper.conf
    augeas { 'update-archiva-wrapper-config':
      lens      => 'Properties.lns',
      incl      => "${home}/conf/wrapper.conf",
      changes   => "set wrapper.java.maxmemory ${maxmemory}",
      require   => [File["${home}/conf/wrapper.conf"]],
      notify    => Service[$service],
    }
  }

  if $max_upload_size != undef {
    augeas { 'set-upload-size':
      lens      => 'Properties.lns',
      incl      => "${installdir}/apps/archiva/WEB-INF/classes/struts.properties",
      changes   => "set struts.multipart.maxSize ${max_upload_size}",
      require   => [Exec['archiva_untar']],
      notify    => Service[$service],
    }
  }

  # in some versions wrapper has: set.ARCHIVA_BASE=.
  # should be: set.default.ARCHIVA_BASE=.
  augeas { 'fix-archiva-base':
    lens      => 'Properties.lns',
    incl      => "${home}/conf/wrapper.conf",
    changes   => [
      "rm set.ARCHIVA_BASE",
      "set set.default.ARCHIVA_BASE .",
    ],
    onlyif    => 'match set.ARCHIVA_BASE size > 0',
    require   => [File["${home}/conf/wrapper.conf"]],
    notify    => Service[$service],
  }

}
