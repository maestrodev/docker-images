require 'spec_helper'

describe 'maestro_nodes::agentrvm' do

  context "when using default params", :compile do
    it { should_not contain_rvm__system_user('undef') }
    it { should contain_rvm__system_user('maestro_agent') }
    it { should_not contain_rvm__system_user('jenkins') }
  end

  context "when changing the agent_user", :compile do
    let(:pre_condition) { "class { 'maestro::params': agent_user => 'username' }" }

    it { should_not contain_rvm__system_user('undef') }
    it { should contain_rvm__system_user('username') }
  end

  context "when wget was already defined", :compile do
    let(:pre_condition) { "package { 'wget': ensure => present }" }

    it { should contain_package('wget') }
    it { should contain_rvm__system_user('maestro_agent') }
  end

  context "when jenkins is installed", :compile do
    let(:pre_condition) { "class { 'jenkins': }" }
    it { should contain_rvm__system_user('jenkins') }
  end
end
