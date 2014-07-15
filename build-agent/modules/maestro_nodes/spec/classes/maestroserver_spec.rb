require 'spec_helper'

describe 'maestro_nodes::maestroserver' do

  let(:params) {{
    :repo => {
        'id' => 'maestro-mirror',
        'username' => 'u',
        'password' => 'p',
        'url' => 'https://repo.maestrodev.com/archiva/repository/all'
    },
    :disabled => false
  }}

  context "when using default params", :compile do
    it { should contain_class('maestro::maestro') }
    it { should contain_class('maestro_nodes::metrics_repo') }
    it { should contain_class('maestro_nodes::database') }
    it { should contain_class('activemq') }
    it { should contain_class('activemq::stomp') }
    it { should contain_class('maestro::plugins') }
  end

  context 'when disabling maestro', :compile do
    let(:params) { super().merge({:disabled => true}) }
    it { should contain_class('maestro::maestro').with( { :enabled => false }) }
  end

end
