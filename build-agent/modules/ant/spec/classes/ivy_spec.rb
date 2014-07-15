require 'spec_helper'

describe "ant::ivy" do
  
  context "default versions" do
    it { should contain_file("/usr/share/apache-ant-1.8.2/lib/ivy-2.2.0.jar") }
  end

  context "specific Ivy version" do
    let(:params) { {
        :version => "2.0.0"
    } }
    it { should contain_file("/usr/share/apache-ant-1.8.2/lib/ivy-2.0.0.jar") }    
  end

  context "specific Ant + Ivy version" do
    let(:pre_condition) { %Q[
      class { 'ant': version => '1.7.1' }
    ] } 
    let(:params) { {
        :version => "2.0.0"
    } }
    it { should contain_file("/usr/share/apache-ant-1.7.1/lib/ivy-2.0.0.jar") }    
  end
end