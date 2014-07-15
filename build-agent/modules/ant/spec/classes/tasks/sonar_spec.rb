require 'spec_helper'

describe "ant::tasks::sonar" do
  
  context "default versions" do
    it { should contain_Ant__Lib('sonar-ant-task').with({
      :source_url => 'http://repository.codehaus.org/org/codehaus/sonar-plugins/sonar-ant-task/1.2/sonar-ant-task-1.2.jar',
      :version    => '1.2'
    })}
    it { should contain_Wget__Fetch("sonar-ant-task-antlib").with_destination("/usr/share/apache-ant-1.8.2/lib/sonar-ant-task-1.2.jar") }
  end

  context "specific tasks version" do
    let(:params) { {
        :version => "2.0"
    } }

    it { should contain_Wget__Fetch("sonar-ant-task-antlib").with_destination("/usr/share/apache-ant-1.8.2/lib/sonar-ant-task-2.0.jar") }
   end
end
