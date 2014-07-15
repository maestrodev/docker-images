require 'spec_helper'
require 'pp'

describe 'maestro::maestro::db' do

  let(:params) { {
    :version     => '',
    :db_password => 'defaultpassword',
  } }

  context "with default postgres version", :compile do
    it { should contain_class('postgresql::server').with_version('8.4') }
  end

  context "with custom postgres version", :compile do
    let(:params) { {
      :version => '9.0',
      :db_password => 'defaultpassword',
    } }

    it { should contain_class('postgresql::server').with_version('9.0') }
    it { should contain_yumrepo('yum.postgresql.org')}

  end
end
