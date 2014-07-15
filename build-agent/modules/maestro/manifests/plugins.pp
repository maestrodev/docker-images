# Maestro default plugins
# define plugins and versions as parameters so they can be set from hiera
# defaults here for backwards compatibility - expect this will likely be
# supplied in most Puppet sites to ease updating
class maestro::plugins(
  $plugins = {
    'maestro-ant-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-archive-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-bamboo-plugin' => { version => '1.1' },
    'maestro-continuum-plugin' => { version => '1.6.1' },
    'maestro-cucumber-plugin' => { version => '1.0.1' },
    'maestro-flowdock-plugin' => { version => '1.0' },
    'maestro-fog-plugin' => { version => '1.10', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-gemfury-plugin' => { version => '1.0' },
    'maestro-git-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-gitblit-plugin' => { version => '1.0', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-httputils-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-irc-plugin' => { version => '1.2' },
    'maestro-jenkins-plugin' => { version => '2.1.2' },
    'maestro-jira-plugin' => { version => '1.0' },
    'maestro-maven-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-puppet-plugin' => { version => '1.1' },
    'maestro-rake-plugin' => { version => '1.2', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-rightscale-plugin' => { version => '1.0' },
    'maestro-rpm-plugin' => { version => '1.1' },
    'maestro-scm-plugin' => { version => '1.0' },
    'maestro-shell-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-ssh-plugin' => { version => '1.0' },
    'maestro-sonar-plugin' => { version => '1.0.2', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-svn-plugin' => { version => '1.1', dir => 'com/maestrodev/maestro/plugins' },
    'maestro-tomcat-plugin' => { version => '1.2', dir => 'com/maestrodev/maestro/plugins' },
  } ) {
  create_resources('maestro::plugin', $plugins)
}
