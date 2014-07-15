require 'spec_helper'

describe 'maestro_nodes::nginx::sonar' do

  let(:params) { {
      :sonar_port => '8083',
      :hostname => 'maestro.acme.com',
      :ssl => false,
  } }

  let(:pre_condition) { "class { 'maestro_nodes::nginxproxy': }" }

  context "with default parameters", :compile do
    it { should contain_nginx__resource__location("sonar_app").with(
                    :ssl => false,
                    :ssl_only => false,
                    :vhost => 'maestro.acme.com',
                    :location => '/sonar/',
                    :proxy => 'http://sonar_app',
                ) }

    it { should contain_nginx__resource__upstream("sonar_app").with_members(["localhost:8083"]) }
  end

  context "with SSL", :compile do
    let(:params) { super().merge ({
        :ssl => true,
    }) }
    it { should contain_nginx__resource__location("sonar_app").with(
                    :ssl => true,
                    :ssl_only => true,
                    :vhost => 'maestro.acme.com',
                    :location => '/sonar/',
                    :proxy => 'http://sonar_app',
                ) }

    it { should contain_nginx__resource__upstream("sonar_app").with_members(["localhost:8083"]) }
  end

end
