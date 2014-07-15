require 'spec_helper'

describe 'maestro::agent::absent' do

  context "with default parameters", :compile do
    it { should contain_user("agent").with_ensure('absent') }
    it { should contain_file("/home/agent").with_ensure('absent') }
    it { should contain_file("/var/maestro-agent").with_ensure('absent') }
    it { should contain_file("/usr/local/src/agent-0.1.0.tar.gz").with_ensure('absent') }
    it { should contain_package("maestro-agent").with_ensure('absent')}
  end

  context "with custom parameters", :compile do
    let(:params) { {
      :user      => 'maestro_agent',
      :user_home => '/var/local/maestro-agent',
      :version   => '1.0.0'
    } }

    it { should contain_user("maestro_agent").with_ensure('absent') }
    it { should contain_file("/var/local/maestro-agent").with_ensure('absent') }
    it { should contain_file("/usr/local/src/agent-1.0.0.tar.gz").with_ensure('absent') }
    it { should contain_package("maestro-agent").with_ensure('absent')}
  end
end
