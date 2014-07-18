node 'default' {

  package { 'wget':
    ensure => present
  } ->
  class { '::jenkins::slave': }

}
