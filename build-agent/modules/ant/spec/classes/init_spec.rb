require 'spec_helper'

describe "ant" do

  context 'default ant version' do
    version = '1.8.2'
    it { should contain_Wget__Fetch("ant").with({ 
      :source => "http://archive.apache.org/dist/ant/binaries/apache-ant-#{version}-bin.tar.gz",
      :destination => "/usr/local/src/apache-ant-#{version}-bin.tar.gz"}) 
    }
    
    it { should contain_file('/usr/bin/ant').with( { 
      :ensure => 'link',
      :target => "/usr/share/apache-ant-#{version}/bin/ant" 
      } ) }
  end
  
  context 'specific ant version' do
    version = '2.0.0'
    let(:params) { {
        :version => version
    } }
    it { should contain_Wget__Fetch("ant").with({ 
      :source => "http://archive.apache.org/dist/ant/binaries/apache-ant-#{version}-bin.tar.gz",
      :destination => "/usr/local/src/apache-ant-#{version}-bin.tar.gz"}) 
    }
    
    it { should contain_file('/usr/bin/ant').with({
      :ensure => 'link',
      :target => "/usr/share/apache-ant-#{version}/bin/ant" }) }
  end
  
end
