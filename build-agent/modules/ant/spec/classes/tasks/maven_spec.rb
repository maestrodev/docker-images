require 'spec_helper'

describe "ant::tasks::maven" do
  
  context "default versions" do
    it { should contain_Ant__Lib('maven-ant-tasks').with({
      :source_url => 'http://archive.apache.org/dist/maven/binaries/maven-ant-tasks-2.1.3.jar',
      :version    => '2.1.3'
    })}
    it { should contain_Wget__Fetch("maven-ant-tasks-antlib").with_destination("/usr/share/apache-ant-1.8.2/lib/maven-ant-tasks-2.1.3.jar") }
  end

  context "specific tasks version" do
    let(:params) { {
        :version => "2.0.0"
    } }
    
    it { should contain_Wget__Fetch("maven-ant-tasks-antlib").with_destination("/usr/share/apache-ant-1.8.2/lib/maven-ant-tasks-2.0.0.jar") }
  end
end
