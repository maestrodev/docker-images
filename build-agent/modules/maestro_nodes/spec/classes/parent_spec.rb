require 'spec_helper'

describe 'maestro_nodes::parent', :compile do

  it { should contain_class('java') }
  it { should contain_package('java').with(
    :name => 'java-1.6.0-openjdk-devel',
    :ensure => 'present') }

end
