# This class is used to install and configure the Maestro agent.
#
#
# ==Parameters
#
# [repo]  A hash containing the artifact repository URL and credentials.
# [package_type] Selects the type of package to use for the install. Either rpm, or tarball.
# [enabled] Enables/disables the service
# [agent_version] The version to install
# [facter] Indicates if the agent should use facter
# [stomp_host] the hostname or IP address of the stomp server
# [maven_servers] a list of maven servers
# [agent_name] the name this agent should identify itself with on the Maestro server
# [maxmemory] the wrapper.java.maxmemory setting to configure in the wrapper.
# [enable_jpda] A boolean indicating whether or not we want to enable JPDA
# [support_email] An email address to send any fatal error logs to from the # agent
# [jmxport] The port number the JMX server will listen on (default 9002)
# [rmi_server_hostname] The ip address the JMX server will listen on (default $ipaddress)
#
class maestro::agent(
  $agent_version = 'present',
  $repo = $maestro::params::repo,
  $package_type = $maestro::params::package_type,
  $enabled = true,
  $facter = true,
  $stomp_host = '',
  $maven_servers = '',
  $agent_name = 'maestro_agent',
  $maxmemory = undef,
  $enable_jpda = false,
  $support_email = "support@maestrodev.com",
  $jmxremote = false,
  $jmxport = '9002',
  $rmi_server_hostname = $ipaddress) inherits maestro::params {

  $basedir = '/usr/local/maestro-agent'

  class { 'maestro::agent::user': } ->
  class { 'maestro::agent::package': } ->
  class { 'maestro::agent::config': } ->
  class { 'maestro::agent::service': }

}
