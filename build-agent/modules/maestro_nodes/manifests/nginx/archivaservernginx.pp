# This class includes a jenkins server with a nginx server in front
class maestro_nodes::nginx::archivaservernginx() {

  include maestro_nodes::archivaserver
  include maestro_nodes::nginx::archiva

}
