require 'spec_helper'

describe 'maestro_nodes::archivaserver', :compile do

  let(:pre_condition) {[
    "class {'maestro::params': db_password => 'mypassword'}",
    "class { 'maestro::maestro::db': }"
  ]}

  it { should contain_postgresql__server__db("archiva").with({
    :user => 'maestro',
    :password => 'mypassword'
  }) }
  it { should contain_class("archiva").with_port(8082) }
end
