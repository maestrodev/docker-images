# This class includes everything needed to install and configure a maestro server
class maestro_nodes::maestroserver(
  $repo = $maestro::params::repo,
  $disabled = false) inherits maestro::params {

  # This hack is to get around hiera boolean shortcomings
  $enabled = $disabled ? { true => false, default => true}

  include maestro
  include maestro_nodes::metrics_repo

  # Maestro master server
  class { 'maestro::maestro':
    repo    => $repo,
    enabled => $enabled,
  }

  include maestro_nodes::database
  class { 'activemq': }
  class { 'activemq::stomp': }
  include maestro::plugins

  if defined(Package['java']) {
    Package['java'] -> Service['activemq']
    Package['java'] -> Service['maestro']
  }
}
