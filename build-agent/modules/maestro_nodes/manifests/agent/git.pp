class maestro_nodes::agent::git(
  $agent_user = $maestro::params::agent_user,
  $agent_group = $maestro::params::agent_group,
  $agent_user_home = $maestro::params::agent_user_home) inherits maestro::params {

  class { '::git': } ->
  ::git::resource::config { "agent-gitconfig":
    user     => $agent_user,
    group    => $agent_group,
    root     => $agent_user_home,
    email    => 'info@maestrodev.com',
    realname => 'MaestroDev',
  }
  # github.com ssh key
  sshkey { 'github.com':
    type => 'ssh-rsa',
    key  => 'AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==',
  }
  # need to work around https://tickets.puppetlabs.com/browse/PUP-1177
  # /etc/ssh/ssh_known_hosts has bad permissions
  case $::kernel {
    'Linux': {
      class { 'ssh::client': }
      Class['ssh::client::install'] -> Sshkey['github.com']
    }
    default: {
    }
  }
}
