require 'spec_helper'

describe 'maestro_nodes::nginx::archivaservernginx', :compile do
  let(:facts) {{:postgres_default_version => '6.4'}}
  let(:pre_condition) {[
    "class { 'maestro::maestro::db': }",
    "class { 'maestro_nodes::nginxproxy': }"
  ]}

  it { should contain_nginx__resource__location('archiva_app') }
  it { should contain_nginx__resource__upstream('archiva_app') }
  it { should contain_class('archiva') }

end
