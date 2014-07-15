require 'spec_helper'

describe 'maestro_nodes::agent' do

  let(:user_home) { "/var/local/maestro-agent" }
  let(:settings_xml) { "#{user_home}/.m2/settings.xml" }

  let(:params) { {
    :repo => {
        'id' => 'maestro-mirror',
        'username' => 'u',
        'password' => 'p',
        'url' => 'https://repo.maestrodev.com/archiva/repository/all'
    },
    :version => '1.0'
  } }

  context "with default params", :compile do
    it { should contain_user('maestro_agent') }

    it { should contain_package('git').with_ensure('present') }
    it { should contain_package('subversion').with_ensure('installed') }

    it { should contain_file(settings_xml).with_owner('maestro_agent') }
    it {
      should contain_file(settings_xml).with_content(
        %r[<properties>\s*<sonar.jdbc.url>jdbc:postgres://localhost/sonar</sonar.jdbc.url>\s*</properties>]
      )
    }
    it { should_not contain_file("#{user_home}/.ssh/config") }

    it {
      should contain_file("server.key").with_path("#{user_home}/.maestro/server.key")
      should contain_file("#{user_home}").with_ensure(:directory)
    }

    it { should_not contain_file("/home/agent").with_ensure(:directory) }
    it { should_not contain_file("/home/agent/.maestro") }
  end

  context "when changing admin in maestro", :compile do
    let(:params) {{}}
    let(:pre_condition) { %Q[
      class {'maestro::params':
        admin_username => 'myuser',
        admin_password => 'mypassword',
      }
    ]}
    it { should contain_file(settings_xml).with_content(%r[<username>myuser</username>]) }
    it { should contain_file(settings_xml).without_content(%r[<username>admin</username>]) }
    it { should contain_file(settings_xml).with_content(%r[<password>mypassword</password>]) }
    it { should contain_file(settings_xml).without_content(%r[<password>admin1</password>]) }
  end

  # ================================================ Linux ================================================

  context "when running on CentOS", :compile do
    it { should contain_package("ruby-json") }
  end

  # ================================================ OS X ================================================

  context "when running on OS X", :compile do
    let(:facts) { {:operatingsystem => 'Darwin', :kernel => 'Darwin', :osfamily => 'Darwin'} }
    it { should_not contain_package("ruby-json") }
  end

end
