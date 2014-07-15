require 'spec_helper'

describe 'svn' do
  context "default parameters" do
    it { should contain_package('subversion').with_ensure('installed') }
  end

  context "with package version" do
    let(:params) {{
        :version => '1.7.0'
    }}
    it { should contain_package('subversion').with_ensure('1.7.0') }
  end
end
