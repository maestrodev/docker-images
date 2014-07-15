require 'spec_helper'

describe 'maestro_nodes::sonarserver', :compile do

  let(:params) { {
    :db_password => 'mypassword'
  } }

  let(:pre_condition) { "class { 'maestro::maestro::db': }" }

  it { should contain_postgresql__server__db("sonar") }
end
