require 'spec_helper'

describe 'maestro_nodes::puppetforge' do

  context "when using default params", :compile do
    it { should_not contain_file('/var/local/maestro-agent/.puppetforge.yml') }
  end

  context "when setting params", :compile do
    let(:params) { {
      :username => 'xxx',
      :password => 'yyy'
    } }

    content = <<EOS
--- 
forge: 'https://forge.puppetlabs.com'
username: 'xxx'
password: 'yyy'
EOS

    it { should contain_file('/var/local/maestro-agent/.puppetforge.yml').with_content(content) }
  end

end
