class maestro::yumrepo(
  $username = undef,
  $password = undef,
  $enabled = 1,
  $snapshots_enabled = 0,
  $metadata_expire = undef,
  $snapshots_metadata_expire = '1m') {

  $base_url = $username ? {
    undef   => "http://yum.maestrodev.com",
    default => "https://${username}:${password}@yum.maestrodev.com",
  }

  yumrepo { 'maestrodev':
    descr    => 'MaestroDev Products EL 6 - $basearch',
    baseurl  => "${base_url}/el/6/\$basearch",
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-maestrodev',
    enabled  => $enabled,
    gpgcheck => 0,
    metadata_expire => $metadata_expire,
  } ->
  file { '/etc/yum.repos.d/maestrodev.repo':
    mode => '0600',
  }

  yumrepo { 'maestrodev-snapshots':
    descr    => 'MaestroDev Snapshots EL 6 - $basearch',
    baseurl  => "${base_url}/snapshots/el/6/\$basearch",
    gpgkey   => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-maestrodev',
    enabled  => $snapshots_enabled,
    gpgcheck => 0,
    metadata_expire => $snapshots_metadata_expire,
  } ->
  file { '/etc/yum.repos.d/maestrodev-snapshots.repo':
    mode => '0600',
  }
}
