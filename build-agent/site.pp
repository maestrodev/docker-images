node 'default' {

  include maestro::params
  include maestro_nodes::repositories

  class { 'epel': }
  class { 'java': }

  class { 'maestro::agent::user': }
  class { 'maestro_nodes::agent::ant': }
  class { 'maestro_nodes::agent::maven': }
  class { 'maestro_nodes::agent::rvm': }
  class { 'maestro_nodes::agent::git': }
  class { 'svn': }
  class { 'maestro_nodes::puppetforge': }
  class { 'maestro_nodes::agent::jenkins': }

  Class['java'] -> Service['jenkins-slave']

}
