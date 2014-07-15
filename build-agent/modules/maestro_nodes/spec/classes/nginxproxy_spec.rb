require 'spec_helper'

describe 'maestro_nodes::nginxproxy' do

  let(:facts) {{:fqdn => "maestro.acme.com"}}

  let(:params) {{ :maestro_port => '8080' }}

  context "with default parameters", :compile do
    it { should contain_nginx__resource__vhost("maestro.acme.com").with(
                    :ssl => false,
                    :listen_port => '80',
                    :proxy => 'http://maestro_app',
                ) }

    it { should contain_nginx__resource__upstream("maestro_app").with_members(["localhost:8080"]) }

    it { should contain_file('/etc/nginx/conf.d/default.conf').with_ensure('absent') }

    it { should contain_service('nginx') }
  end

  context "with SSL", :compile do
    let(:params) { super().merge( {
        :ssl => true,
        :ssl_cert => '/etc/ssl/certs/maestro.acme.com.crt',
        :ssl_key => '/etc/ssl/certs/maestro.acme.com.key',
    }) }
    it { should contain_nginx__resource__vhost("maestro.acme.com").with(
                    :ssl => true,
                    :ssl_cert => '/etc/ssl/certs/maestro.acme.com.crt',
                    :ssl_key => '/etc/ssl/certs/maestro.acme.com.key',
                    :listen_port => '443',
                    :proxy => 'http://maestro_app',
                ) }

    it { should contain_nginx__resource__upstream("maestro_app").with_members(["localhost:8080"]) }

    it { should contain_file('/etc/nginx/conf.d/default.conf').with_source("puppet:///modules/maestro_nodes/nginx/default.conf") }

    it { should contain_service('nginx') }
  end

end
