require 'spec_helper'

describe 'statsd' do

  let(:facts) {{
    :kernel          => 'Linux',
    :operatingsystem => 'CentOS',
    :operatingsystemrelease => '6.2',
    :osfamily        => 'RedHat',
    :architecture    => 'x86_64'
  }}

  it { should contain_service('statsd').with_ensure('running') }

end
