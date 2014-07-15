# This class includes a maestro server with a nginx server in front
class maestro_nodes::nginx::maestroservernginx() {

  include maestro_nodes::maestroserver
  include maestro_nodes::nginxproxy

}
