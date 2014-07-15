require 'spec_helper'

describe 'maestro_nodes::nginx::jenkinsservernginx', :compile do

  let(:pre_condition) { "class { 'maestro_nodes::nginxproxy': }" }

  it { should contain_nginx__resource__location('jenkins_app') }
  it { should contain_nginx__resource__upstream('jenkins_app') }
  it { should contain_class('jenkins') }

end
