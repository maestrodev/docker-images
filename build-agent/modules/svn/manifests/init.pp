class svn(
  $version = installed,
) {
  package { subversion:
    ensure => $version,
  }
}

