require 'spec_helper'

describe 'maestro_nodes::rubygems' do

  let(:user_home) { "/var/local/maestro-agent" }
  let(:params) {{}}

  context "when not using parameters", :compile do
    it { should_not contain_file('/var/local/maestro-agent/.gem/credentials') }
    it { should_not contain_file('/var/local/maestro-agent/.gem/geminabox') }
  end

  context "when configuring rubygems", :compile do
    let(:params) { super().merge(:api_key => 'xxx') }
    it { should contain_file('/var/local/maestro-agent/.gem/credentials').with_mode('0600') }
    it { should_not contain_file('/var/local/maestro-agent/.gem/geminabox') }
  end

  context "when configuring geminabox", :compile do
    let(:params) { super().merge(:geminabox_repo => 'http://x:y@www.acme.com') }
    it { should_not contain_file('/var/local/maestro-agent/.gem/credentials') }
    it { should contain_file('/var/local/maestro-agent/.gem/geminabox').with_mode('0600') }
  end

  context "when configuring both", :compile do
    let(:params) { super().merge(:api_key => 'xxx', :geminabox_repo => 'http://x:y@www.acme.com') }
    it { should contain_file('/var/local/maestro-agent/.gem/credentials').with_mode('0600') }
    it { should contain_file('/var/local/maestro-agent/.gem/geminabox').with_mode('0600') }
  end
end
