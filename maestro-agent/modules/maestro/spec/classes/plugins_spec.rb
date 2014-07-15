require 'spec_helper'

describe 'maestro::plugins' do

  let(:pre_condition) { [
    "class { 'maestro::params': repo => {'url'=>'http://xxx'} }",
    'file { [$maestro::params::srcdir, "${maestro::params::user_home}/.maestro/plugins"]: ensure => directory }',
    "service { 'maestro': }",
    "exec { 'startup_wait': command => '/bin/startup_wait' }"
  ] }

  context "when using defaults", :compile do
    # Test that defaults are created by picking a plugin always likely to be
    # there
    it { should contain_maestro__plugin("maestro-ssh-plugin") }
  end
end


