require 'spec_helper'

describe 'maestro::test::remote-control', :compile do
  let(:params) { {
    :repo               => {
      'id'       => 'maestro-mirror',
      'username' => 'u',
      'password' => 'p',
      'url'      => 'https://repo.maestrodev.com/archiva/repository/all'
    }
  } }

  packages = ['firefox', 'xorg-x11-xauth', 'xorg-x11-server-utils', 'xorg-x11-server-Xvfb']
  packages.each {|p| it { should contain_package(p).with_ensure('installed') } }

end
