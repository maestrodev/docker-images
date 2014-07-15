require 'spec_helper'

describe 'maestro::agent' do

  let(:user) { "maestro_agent" }
  let(:agent_version) { '2.1.0' }
  let(:params) {{
      :repo => {
          'id' => 'maestro-mirror',
          'username' => 'u',
          'password' => 'p',
          'url' => 'https://repo.maestrodev.com/archiva/repository/all'
      },
      :agent_version => agent_version,
  }}
  let(:agent_config) { "maestro_agent.json" }
  let(:agent_config_file) { "/var/local/maestro-agent/conf/maestro_agent.json" }

  context "when using default parameters", :compile do
    it { should contain_file("/var/local/maestro-agent").with(
      :ensure => :directory,
      :owner  => user)
    }
    it { should contain_user(user).with_groups('root') }
    it { should_not contain_augeas("maestro-agent-wrapper-maxmemory") }
  end

  context "with a default support address", :compile do
    it { should contain_file(agent_config).with_path(agent_config_file) }
    it { should contain_file(agent_config).with_content(%r["to": "support@maestrodev.com"]) }
  end
  
  context "with a configured support address", :compile do
    let(:params) { super().merge({:support_email => "support@example.com"})}
    it { should contain_file(agent_config).with_path(agent_config_file) }
    it { should contain_file(agent_config).with_content(%r["to": "support@example.com"]) }
  end

  context "when using a different username", :compile do
    let(:user) { 'agent' }
    let(:pre_condition) { "class { 'maestro::params': agent_user => #{user} }" }

    it { should contain_file('/etc/sysconfig/maestro-agent').with_content(/^RUN_AS_USER=#{user}$/) }
  end

  context "when setting the maxmemory", :compile do
    let(:params) { super().merge({:maxmemory => 512})}
    it { should contain_augeas("maestro-agent-wrapper-maxmemory").with_changes(["set wrapper.java.maxmemory 512"]) }
  end


  # ================================================ Tarball install =========================================

  context "when installing from a tarball", :compile do
    let(:params) { super().merge({ :package_type => 'tarball' }) }

    it { should contain_file("/var/local") }
    it { should contain_file('/var/local/maestro-agent/conf/wrapper.conf').with_ensure('link') }
    it { should contain_file('/etc/init.d/maestro-agent').with_ensure('link') }
    it { should contain_exec("unpack-agent").with_cwd('/usr/local') }

    context "when passing only agent snapshot version", :compile do
      let(:agent_version) { '2.1.1-20120430.110153-41' }
      it { should contain_wget__fetch("fetch-agent").with(
        'source' => "https://repo.maestrodev.com/archiva/repository/all/com/maestrodev/lucee/agent/2.1.1-SNAPSHOT/agent-2.1.1-20120430.110153-41-bin.tar.gz",
        'destination' => "/usr/local/src/agent-2.1.1-20120430.110153-41-bin.tar.gz"
      )}
    end

    context "when passing a release version", :compile do
      let(:agent_version) { '2.1.0' }
      it { should contain_wget__fetch("fetch-agent").with(
        'source' => "https://repo.maestrodev.com/archiva/repository/all/com/maestrodev/lucee/agent/2.1.0/agent-2.1.0-bin.tar.gz",
        'destination' => "/usr/local/src/agent-2.1.0-bin.tar.gz"
      )}
    end
  end
  
  # ================================================ rpm install =========================================

  context "when installing from an rpm", :compile do
    let(:params) { super().merge({:package_type => 'rpm'}) }

    shared_examples :rpm do
      it { should_not contain_exec("unpack-agent") }
      it { should_not contain_file('/var/local/maestro-agent/conf/wrapper.conf') }
      it { should_not contain_file('/etc/init.d/maestro-agent') }
      it { should contain_package("maestro-agent") }
    end

    context "when installing a release version", :compile do
      let(:base_version) { agent_version }
      it_behaves_like :rpm
    end

    context "when installing a snapshot version", :compile do
      let(:base_version) { "2.1.0-SNAPSHOT" }
      let(:agent_version) { "2.1.0-20120430.110153-41" }
      it_behaves_like :rpm
    end

    context "when installing an older version", :compile do
      let(:agent_version) { '2.0.0' }
      it { should contain_file('/var/local/maestro-agent/conf/wrapper.conf').with_ensure('link') }
      it { should contain_file('/etc/init.d/maestro-agent').with_ensure('link') }
    end
  end

  # ================================================ Linux ================================================

  context "when running on CentOS", :compile do
    let(:params) { super().merge({:package_type => 'rpm'}) }

    it { should_not contain_file("/etc/init.d/maestro-agent") }
    it { should contain_file("/etc/sysconfig/maestro-agent").with_content(%r{^WRAPPER_CMD=/usr/local/maestro-agent/bin/wrapper$}) }
    it { should_not contain_file("/Library/LaunchDaemons/com.maestrodev.agent.plist") }
    it { should contain_service("maestro-agent").with({
      :ensure => 'running',
      :enable => true
    }) }

    context "when installing an older version", :compile do
      let(:agent_version) { '2.0.0' }
      it { should contain_file("/etc/init.d/maestro-agent") }
    end
  end

  # ================================================ OS X ================================================

  context "when running on OS X", :compile do
    let(:facts) { {:operatingsystem => 'Darwin', :kernel => 'Darwin', :osfamily => 'Darwin'} }

    it { should_not contain_file("/etc/init.d/maestro-agent") }
    it { should contain_file("/Library/LaunchDaemons/com.maestrodev.agent.plist") }
    it { should contain_service("maestro-agent").with({
      :ensure => 'running',
      :enable => true
    }) }
  end
end
