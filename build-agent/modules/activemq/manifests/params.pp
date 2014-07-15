class activemq::params(
  $apache_mirror = 'http://archive.apache.org/dist/',
  $home = '/usr/share',
  $user = 'activemq',
  $group = 'activemq',
  $system_user = true,
  $max_memory = undef,
  $console = true,
  $package_type = 'tarball'
  ) {

  # path flag for the activemq init script template
  case $architecture {
    'x86_64','amd64': {
      $architecture_flag = '64'
    }
    'i386': {
      $architecture_flag = '32'
    }
    default: { fail("Unsupported architecture ${architecture}") }
  }
}
