require 'spec_helper'

describe 'activemq' do
  let(:facts) { {:architecture => 'x86_64'} }

  context "when using default parameters", :compile do
    it { should contain_service('activemq').with_ensure('running') }

    context 'should generate valid init.d' do
      it { should contain_file("/etc/init.d/activemq").with_content(%r[ACTIVEMQ_HOME="/usr/share/activemq"]) }
      it { should contain_file("/etc/init.d/activemq").with_content(%r[WRAPPER_CMD="/usr/share/activemq/bin/linux-x86-64/wrapper"]) }
      it { should contain_file("/etc/init.d/activemq").with_content(%r[WRAPPER_CONF="/usr/share/activemq/bin/linux-x86-64/wrapper.conf"]) }
      it { should contain_file("/etc/init.d/activemq").with_content(%r[RUN_AS_USER=activemq]) }
    end

    context "should generate a valid wrapper.conf" do
      it { should contain_file('wrapper.conf').with_content(%r[ACTIVEMQ_HOME=/usr/share/activemq]) }
      it { should contain_file('wrapper.conf').with_content(%r[ACTIVEMQ_BASE=/usr/share/activemq]) }
      it { should_not contain_augeas('activemq-maxmemory') }
    end

    it { should_not contain_augeas('activemq-console') }
  end

  context "when installing an rpm", :compile do
    let(:params) { {
      :package_type => 'rpm'
    } }
    it { should contain_package('activemq').with_ensure('present') }
    it { should_not contain_file('/etc/init.d/activemq') }
    it { should_not contain_augeas('activemq-maxmemory') }
  end

  context "when using custom home", :compile do
    let(:params) { {
      :home => '/usr/local'
    } }
    context 'should generate valid init.d' do
      it { should contain_file("/etc/init.d/activemq").with_content(%r[ACTIVEMQ_HOME="/usr/local/activemq"]) }
      it { should contain_file("/etc/init.d/activemq").with_content(%r[WRAPPER_CMD="/usr/local/activemq/bin/linux-x86-64/wrapper"]) }
      it { should contain_file("/etc/init.d/activemq").with_content(%r[WRAPPER_CONF="/usr/local/activemq/bin/linux-x86-64/wrapper.conf"]) }
      it { should contain_file("/etc/init.d/activemq").with_content(%r[RUN_AS_USER=activemq]) }
    end

    context "should generate a valid wrapper.conf" do
      it { should contain_file('wrapper.conf').with_content(%r[ACTIVEMQ_HOME=/usr/local/activemq]) }
      it { should contain_file('wrapper.conf').with_content(%r[ACTIVEMQ_BASE=/usr/local/activemq]) }
    end
  end

  context "when using custom memory setting", :compile do
    let(:params) { {
      :max_memory => '256'
    } }

    it { should contain_augeas('activemq-maxmemory').with_changes(%r[wrapper.java.maxmemory 256]) }
  end

  context "when disabling the console", :compile do
    let(:params) { {
      :console => false
    } }

    it { should contain_augeas('activemq-console').with_changes(%r[rm beans/import]) }
  end

end
