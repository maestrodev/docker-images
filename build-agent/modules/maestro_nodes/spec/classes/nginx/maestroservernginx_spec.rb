require 'spec_helper'

describe 'maestro_nodes::nginx::maestroservernginx', :compile do

  let(:facts) {{:fqdn => 'puppet.acme.com', :custom_location => 'maestroservernginx'}}

  it { should contain_nginx__resource__vhost('puppet.acme.com').with_proxy('http://maestro_app') }
  it { should contain_nginx__resource__upstream('maestro_app') }
  it { should contain_class('maestro::maestro') }

end
