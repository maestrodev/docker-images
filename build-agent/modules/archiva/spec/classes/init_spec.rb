require 'spec_helper'

describe 'archiva' do
  let(:version) { "1.3.5" }
  let(:params) {{ :version => version }}
  let(:jetty_config_file) { '/var/local/archiva/conf/jetty.xml' }
  let(:security_config_file) { '/var/local/archiva/conf/security.properties' }

  context "when installing default version 1.3.5", :compile do
    it do should contain_wget__fetch('archiva_download').with(
        'source'      => "http://archive.apache.org/dist/archiva/1.3.5/binaries/apache-archiva-1.3.5-bin.tar.gz",
        'user'        => nil,
        'password'    => nil
    ) 
    end
    it "should configure the archiva JDBC connection" do
      content = subject.resource('file', jetty_config_file).send(:parameters)[:content]
      content.should =~ %r[jdbc/archiva]
      content.should_not =~ %r[org\.eclipse]
    end
  end

  context "when installing version 1.3.4", :compile do
    let(:version) { "1.3.4" }

    it do should contain_wget__fetch('archiva_download').with(
        'source'      => "http://archive.apache.org/dist/archiva/binaries/apache-archiva-1.3.4-bin.tar.gz",
        'user'        => nil,
        'password'    => nil
    ) 
    end
  end

  context "when installing version 1.4-M1", :compile do
    let(:version) { "1.4-M1" }

    it do should contain_wget__fetch('archiva_download').with(
        'source'      => "http://archive.apache.org/dist/archiva/binaries/apache-archiva-1.4-M1-bin.tar.gz",
        'user'        => nil,
        'password'    => nil
    ) 
    end

    it "should configure the archiva JDBC connection" do
      content = subject.resource('file', jetty_config_file).send(:parameters)[:content]
      content.should_not =~ %r[jdbc/archiva]
      content.should_not =~ %r[org\.eclipse]
    end
  end

  context "when installing version 1.4-M3", :compile do
    let(:version) { "1.4-M3" }
    it "should not configure the archiva JDBC connection" do
      should contain_file(jetty_config_file)
      content = subject.resource('file', jetty_config_file).send(:parameters)[:content]
      content.should_not =~ %r[jdbc/archiva]
      content.should =~ %r[org\.eclipse]
    end
  end


  context "when installing version 2.0.0", :compile do
    let(:version) { "2.0.0" }

    it do should contain_wget__fetch('archiva_download').with(
        'source'      => "http://archive.apache.org/dist/archiva/2.0.0/binaries/apache-archiva-2.0.0-bin.tar.gz",
        'user'        => nil,
        'password'    => nil
    )
    end

    it { should contain_file('/var/local/archiva/conf/jetty.xml').with_content(/org.apache.tomcat.jdbc.pool.DataSource/) }
  end

  context "when downloading archiva from a mirror", :compile do
    let(:params) { super().merge({
      :apache_mirror => "http://mirror.internode.on.net/pub/apache"
    }) }

    it do should contain_wget__fetch('archiva_download').with(
        'source'      => "http://mirror.internode.on.net/pub/apache/archiva/#{version}/binaries/apache-archiva-#{version}-bin.tar.gz",
        'user'        => nil,
        'password'    => nil
    ) 
    end
  end

  context "when downloading archiva from another repo", :compile do
    let(:params) { super().merge({ :repo => {
        'url'      => 'http://repo1.maven.org/maven2',
      }
    }) }

    it 'should fetch archiva from repo' do
      should contain_wget__fetch('archiva_download').with(
        'source'      => "http://repo1.maven.org/maven2/org/apache/archiva/archiva-jetty/#{version}/archiva-jetty-#{version}-bin.tar.gz",
        'user'        => nil,
        'password'    => nil)
    end
  end

  context "when downloading archiva from another repo with credentials", :compile do
    let(:params) { super().merge({ :repo => {
        'url'      => 'http://repo1.maven.org/maven2',
        'username' => 'u',
        'password' => 'p'
      }
    }) }

    it 'should fetch archiva with username and password' do
      should contain_wget__fetch('archiva_download').with(
        'source'      => "http://repo1.maven.org/maven2/org/apache/archiva/archiva-jetty/#{version}/archiva-jetty-#{version}-bin.tar.gz",
        'user'        => 'u',
        'password'    => 'p')
    end
  end

  context 'when application URL is not set', :compile do    
    it 'should set the HOME variable correctly in the startup script' do
      content = subject.resource('file', security_config_file).send(:parameters)[:content]
      content.should =~ %r[application\.url = http://localhost:8080/archiva/]
    end
  end
  

  context 'when application URL is set', :compile do
    let(:params) { super().merge({ :application_url => 'http://someurl/' }) }
    
    it 'should set the HOME variable correctly in the startup script' do
      content = subject.resource('file', security_config_file).send(:parameters)[:content]
      content.should =~ %r[application\.url = http://someurl/]
    end
  end

  context "when cookie path is set", :compile do
    let(:params) { super().merge({ :cookie_path => "/" }) }

    security_config_file="/var/local/archiva/conf/security.properties"
    it "should set the cookie paths" do
      should contain_file(security_config_file)
      content = subject.resource('file', security_config_file).send(:parameters)[:content]
      content.should =~ %r[security\.signon\.path=/]
      content.should =~ %r[security\.rememberme\.path=/]
    end
  end

  context "when cookie path is not set", :compile do
    security_config_file="/var/local/archiva/conf/security.properties"
    it "should not set the cookie paths" do
      should contain_file(security_config_file)
      content = subject.resource('file', security_config_file).send(:parameters)[:content]
      content.should_not =~ %r[security\.signon\.path]
      content.should_not =~ %r[security\.rememberme\.path]
    end
  end

  context "when upload size is set", :compile do
    let(:params) { super().merge({ :max_upload_size => 10485760 }) }

    it { should contain_augeas('set-upload-size') }
  end

  context "when upload size is not set", :compile do
    it { should_not contain_augeas('set-upload-size') }
  end
end
