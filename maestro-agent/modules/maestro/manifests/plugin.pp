define maestro::plugin($version, $dir = 'com/maestrodev') {
  include maestro::params
  include wget

  $user_home = $maestro::params::user_home
  $maestro_enabled = $maestro::params::enabled

  if $maestro_enabled {
    Exec { path => '/bin:/usr/bin' }

    # If the version is a Maven snapshot, transform the base version to it's
    # SNAPSHOT indicator
    if $version =~ /^(.*)-[0-9]{8}\.[0-9]{6}-[0-9]+$/ {
      $base_version = "${1}-SNAPSHOT"
    } else {
      $base_version = $version
    }

    $plugin_folder = "${user_home}/.maestro/plugins"
    $plugin_file = "${name}-${version}-bin.zip"

    # download the plugin to /usr/local/src
    wget::fetch { "fetch-maestro-plugin-${name}":
      user        => $maestro::params::repo['username'],
      password    => $maestro::params::repo['password'],
      source      => "${maestro::params::repo['url']}/${dir}/${name}/${base_version}/${name}-${version}-bin.zip",
      destination => "${maestro::params::srcdir}/${name}-${version}-bin.zip",
      require     => [File[$maestro::params::srcdir], File["${user_home}/.maestro/plugins"]],
    } ->

    # copy to .maestro/plugins if it hasn't been installed already
    # currently make sure this is before Maestro starts, so that they are
    # available for any seed data that might require them
    exec { "rm -f ${plugin_folder}/failed/${plugin_file} && cp ${maestro::params::srcdir}/${name}-${version}-bin.zip ${plugin_folder}/${plugin_file}":
      unless  => "test -s ${plugin_folder}/installed/${plugin_file}",
      before  => Service[maestro],
    } ->

    # verify that plugin has been installed correctly in Maestro
    exec { "wait-plugin-installed-${name}":
      command   => "test -s ${plugin_folder}/installed/${plugin_file} || test -s ${plugin_folder}/failed/${plugin_file}",
      unless    => "test -s ${plugin_folder}/installed/${plugin_file} || test -s ${plugin_folder}/failed/${plugin_file}",
      tries     => 30,
      try_sleep => 4,
      require   => [Exec['startup_wait']],
    } ->
    exec { "assert-plugin-installed-${name}":
      command   => "test -s ${plugin_folder}/installed/${plugin_file}",
      unless    => "test -s ${plugin_folder}/installed/${plugin_file}",
    }
  }
}
