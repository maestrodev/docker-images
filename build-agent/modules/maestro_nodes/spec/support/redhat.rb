# common utilities for RedHat servers

shared_context :redhat do

  let(:redhat_facts) {{
    :ipaddress       => '192.168.1.1',
    :kernel          => 'Linux',
    :operatingsystem => 'RedHat',
    :lsbmajdistrelease => '6',
    :osfamily        => 'RedHat',
    :postgres_default_version => '8.4',
    :architecture    => 'x86_64',
    :concat_basedir  => "/tmp/concat", # Until we can upgrade rspec-puppet and supply this via default_facts
  }}

  let(:facts) { redhat_facts }
end
