require 'spec_helper'

describe 'maestro_nodes::puppetenterprise', :compile do

  let(:params) { {
      :repo => {
          'id' => 'maestro-mirror',
          'username' => 'u',
          'password' => 'p',
          'url' => 'https://repo.maestrodev.com/archiva/repository/all'
      },
  } }

  destdir = '/usr/local/src/puppet-enterprise-2.7.1-el-6-x86_64'
  it { should contain_wget__authfetch('fetch-pe').with_destination '/usr/local/src/puppet-enterprise-el-6-x86_64-2.7.1.tar.gz' }
  it { should contain_exec('unpack-pe').with(:command =>  'tar -xvf puppet-enterprise-el-6-x86_64-2.7.1.tar.gz',
                                             :cwd => '/usr/local/src',
                                             :creates => destdir)}
  it { should contain_file("#{destdir}/puppet-enterprise-installer-answers.txt")}
  it { should contain_exec('install-pe').with(:command => '/usr/local/src/puppet-enterprise-2.7.1-el-6-x86_64/puppet-enterprise-installer -a puppet-enterprise-installer-answers.txt',
                                              :cwd => destdir,
                                              :timeout => 0,
                                              :creates => '/opt/puppet')}
  it { should contain_file('/etc/puppetlabs/facter/facts.d/puppet_enterprise_installer.txt')}
  it { should contain_exec('pe-puppet-agent').with( :command => '/opt/puppet/bin/puppet agent --test',
                                                    :returns => [0, 2])}

end