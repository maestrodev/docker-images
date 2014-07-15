require 'spec_helper'

describe 'wget' do

  context 'running on OS X' do
    let(:facts) { {:operatingsystem => 'Darwin'} }

    it { should_not contain_package('wget') }
  end

  context 'running on CentOS' do
    let(:facts) { {:operatingsystem => 'CentOS'} }

    it { should contain_package('wget') }
  end

end
