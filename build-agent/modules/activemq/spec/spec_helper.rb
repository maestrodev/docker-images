require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.before(:each) do
    Puppet::Util::Log.level = :warning
    Puppet::Util::Log.newdestination(:console)
  end
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.default_facts = {
    :operatingsystem => 'CentOS',
    :operatingsystemrelease => '6.5',
    :kernel => 'Linux',
    :osfamily => 'RedHat'
  }
end

shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end
