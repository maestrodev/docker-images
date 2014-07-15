require 'spec_helper'

UUID = 'd3c8a345b14f6a1b42251aef8027ab57'
USER = 'user'

describe 'svn::config::credentials' do
  let(:pre_condition) { %Q[
    class { 'svn::config':
      user => '#{USER}',
    } 
  ] }
  let(:title) { UUID }
  let(:params) {{
    :realmstring => '<https://svn.example.com:443> Committers',
    :username => 'brett',
    :password => 'PaSsWoRd',
  }}
  it "should create the simple auth credentials" do
    file = "/home/user/.subversion/auth/svn.simple/#{UUID}"
    should contain_file(file).with_owner(USER)
    content = param_value(catalogue, 'file', file, 'content')
    content.should =~ %r[V 40]
    content.should =~ %r[<https://svn.example.com:443> Committers]
    content.should =~ %r[V 5]
    content.should =~ %r[brett]
    content.should =~ %r[V 8]
    content.should =~ %r[PaSsWoRd]
  end
end
