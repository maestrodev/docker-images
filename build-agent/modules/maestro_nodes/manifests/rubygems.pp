# Configure agents to push gems to rubygems and/or a geminabox repository
class maestro_nodes::rubygems(
  $user = $maestro::params::agent_user,
  $group = $maestro::params::agent_group,
  $home = $maestro::params::agent_user_home,
  $api_key = undef,
  $geminabox_repo = undef) inherits maestro::params {

  File {
    owner => $user,
    group => $group,
  }

  if $api_key != undef or $geminabox_repo != undef {

    file { "${home}/.gem":
      ensure => directory,
    }

    if $api_key != undef {

      file { "${home}/.gem/credentials":
        mode    => '0600',
        content => "---
:rubygems_api_key: ${api_key}",
      }
    }

    if $geminabox_repo != undef {

      file { "${home}/.gem/geminabox":
        mode    => '0600',
        content => "---
:host: ${geminabox_repo}",
      }
    }
  }

}
