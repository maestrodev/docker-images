class svn::config(
  $user,
  $homedir="/home/$user",
  $group=$user
) {
  include svn

  file { "$homedir/.subversion":
    owner   => $user,
    group   => $group,
    mode    => "0700",
    ensure  => directory,
    require => User[$user],
  } ->
  file { "$homedir/.subversion/auth":
    owner   => $user,
    group   => $group,
    mode    => "0700",
    ensure  => directory,
  }
}
