require 'spec_helper'

describe 'maestro_nodes::nginx::jenkins' do

  let(:params) { {
      :jenkins_port => '8181',
      :hostname => 'maestro.acme.com',
      :ssl => false,
  } }

  let(:pre_condition) { "class { 'maestro_nodes::nginxproxy': }" }

  context "with default parameters", :compile do
    it { should contain_nginx__resource__location("jenkins_app").with(
                    :ssl => false,
                    :ssl_only => false,
                    :vhost => 'maestro.acme.com',
                    :location => '/jenkins/',
                    :proxy => 'http://jenkins_app',
                ) }

    it { should contain_nginx__resource__upstream("jenkins_app").with_members(["localhost:8181"]) }
  end

  context "with SSL", :compile do
    let(:params) { super().merge ({
        :ssl => true,
    }) }
    it { should contain_nginx__resource__location("jenkins_app").with(
                    :ssl => true,
                    :ssl_only => true,
                    :vhost => 'maestro.acme.com',
                    :location => '/jenkins/',
                    :proxy => 'http://jenkins_app',
                ) }

    it { should contain_nginx__resource__upstream("jenkins_app").with_members(["localhost:8181"]) }
  end

end
