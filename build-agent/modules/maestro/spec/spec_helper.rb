Dir["./spec/support/**/*.rb"].each {|f| require f}
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
    :osfamily => 'RedHat',
    :concat_basedir => '/tmp/concat'
  }

  c.before do
    # work around https://tickets.puppetlabs.com/browse/PUP-1547
    # ensure that there's at least one provider available by emulating that any command exists
    require 'puppet/confine/exists'
    Puppet::Confine::Exists.any_instance.stubs(:which => '')
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(:root? => true)
  end
end

shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end
