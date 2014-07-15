define svn::config::servers( 
  $plaintext_passwords = false,
  $owner = $svn::config::user,
  $group = $svn::config::group,
  $homedir = $svn::config::homedir,
) {
  if $plaintext_passwords {
    file { "$homedir/.subversion/servers":
      owner  => $owner,
      group  => $group,
      mode   => "0600",
      source => "puppet:///modules/svn/servers",
    }
  }
}
