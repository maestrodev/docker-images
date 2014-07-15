require 'spec_helper'
require 'json'

describe 'maestro::lucee' do

  let(:lucee_config_file) { '/var/local/maestro/conf/maestro_lucee.json' }

  let(:params) { {
      :config_dir          => "/var/local/maestro/conf",
      :agent_auto_activate => false,
  } }
  let(:pre_condition) { [
    "anchor { 'maestro::maestro::package::end': }",
    "service { 'maestro': }"
  ] }

  context "with default config", :compile do
    it "should set the defaults correctly" do
      should contain_file(lucee_config_file)
      content = subject.resource('file', lucee_config_file).send(:parameters)[:content]
      config = JSON.parse(content)
      config["is_demo"].should eq false
      config["lucee"]["agent_auto_activate"].should eq false
      config["lucee"]["log"]["level"].should eq "INFO"
      config["lucee"]["database"]["server"].should eq "postgres"
      config["lucee"]["database"]["host"].should eq "localhost"
      config["lucee"]["database"]["port"].should eq 5432
      config["lucee"]["database"]["user"].should eq "maestro"
      config["lucee"]["database"]["pass"].should eq "maestro"
      config["lucee"]["database"]["database_name"].should eq "luceedb"
    end
    
    it { should contain_file('/etc/maestro_lucee.json').with_ensure("absent") }
  end

  context "with different configuration directory", :compile do
    let(:params) { super().merge( { :config_dir => "/etc" } ) }
    it { should contain_file('/etc/maestro_lucee.json') }
  end

  context "with different logging level", :compile do
    let(:params) { super().merge( { :logging_level => "ERROR" } ) }

    it { should contain_file(lucee_config_file).with_content(/"level": "ERROR"$/) }
  end

  context "with different logging level via maestro::params", :compile do
    let(:pre_condition) { super() << 'class { "maestro::params": logging_level => "WARN" }' }

    it { should contain_file(lucee_config_file).with_content(/"level": "WARN"$/) }
  end

  context "with different database", :compile do

    shared_examples :db do
      it "should create the json file" do
        content = subject.resource('file', lucee_config_file).send(:parameters)[:content]
        config = JSON.parse(content)
        config["lucee"]["database"]["server"].should eq "mysql"
        config["lucee"]["database"]["host"].should eq "host"
        config["lucee"]["database"]["port"].should eq 1234
        config["lucee"]["database"]["user"].should eq "username"
        config["lucee"]["database"]["pass"].should eq "password"
        config["lucee"]["database"]["database_name"].should eq "database"
      end
    end

    context "via parameters", :compile do
      let(:params) { super().merge( { 
        :username => "username",
        :password => "password",
        :host => "host",
        :type => "mysql",
        :port => "1234",
        :database => "database",
      } ) }

      it_behaves_like :db
    end

    context "via maestro::lucee::db", :compile do
      let(:pre_condition) {
        super() << %Q[
          class { 'maestro::lucee::db':
             username => "username",
             password => "password",
             host => "host",
             type => "mysql",
             port => "1234",
             database => "database",
          }
        ]
      }

      it_behaves_like :db
    end

    context "via maestro::params", :compile do
      let(:pre_condition) {
        super() << %Q[
          class { 'maestro::params':
             db_username => "username",
             db_password => "password",
             db_host => "host",
             db_port => "1234",
          }
          class { 'maestro::lucee::db':
             type => "mysql",
             database => "database",
          }
        ]
      }

      it_behaves_like :db
    end
  end

end
