class maestro_nodes::androidsdk($user, $group, $home, $proxy_host = undef, $proxy_port = undef){
  
  #Android SDK
  class { 'android':
    user => $user,
    group => $group,
    proxy_host => $proxy_host,
    proxy_port => $proxy_port,
  }

  android::platform{ [ 'android-16', 'android-15' ]: }
  
  $sdk_home = $android::paths::sdk_home
  
  file { "${home}/androidsdk.properties":
    ensure  => present,
    content => template('maestro_nodes/androidsdk.properties.erb'),
    owner   => $user,
    group   => $group,
    mode    => '0644',
  }
  
  # add a custom fact
  file { '/etc/facter/facts.d/android.yaml':
    content => "android_version: ${android::version}",
    notify  => Service['maestro-agent'],
  }
  file { '/etc/facts.d/android.yaml':
    ensure => absent,
  }
}
