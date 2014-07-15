# This class includes a jenkins server with a nginx server in front
class maestro_nodes::nginx::jenkinsservernginx() {

  include maestro_nodes::jenkinsserver
  include maestro_nodes::nginx::jenkins

}
