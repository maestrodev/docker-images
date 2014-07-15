# Copyright 2011 MaestroDev
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This activemq class is currently targeting an X86_64 deploy, adjust as needed

class activemq(
  $apache_mirror = $activemq::params::apache_mirror,
  $version = undef,
  $home = $activemq::params::home,
  $user = $activemq::params::user,
  $group = $activemq::params::group,
  $system_user = $activemq::params::system_user,
  $max_memory = $activemq::params::max_memory,
  $console = $activemq::params::console,
  $package_type = $activemq::params::package_type,
  $architecture_flag = $activemq::params::architecture_flag) inherits activemq::params {

  $wrapper = $package_type ? {
    'tarball' => "${home}/activemq/bin/linux-x86-${architecture_flag}/wrapper.conf",
    'rpm'     => '/etc/activemq/activemq-wrapper.conf',
  }

  case $package_type {
    'tarball': {
      anchor { 'activemq::package::begin': } -> Class['activemq::package::tarball'] -> anchor { 'activemq::package::end': }
      class { 'activemq::package::tarball':
        version => $version,
      }
    }
    'rpm': {
      anchor { 'activemq::package::begin': } -> Class['activemq::package::rpm'] -> anchor { 'activemq::package::end': }
      class { 'activemq::package::rpm':
        version => $version,
      }
    }
    default: {
      fail("Invalid ActiveMQ package type: ${package_type}")
    }
  }

  if ! $console {
    augeas { 'activemq-console':
      changes => [ 'rm beans/import' ],
      incl    => "${activemq::home}/activemq/conf/activemq.xml",
      lens    => 'Xml.lns',
      require => Anchor['activemq::package::end'],
      notify  => Service['activemq'],
    }
  }

  if $max_memory != undef {
    augeas { 'activemq-maxmemory':
      changes => [ "set wrapper.java.maxmemory ${max_memory}" ],
      incl    => $wrapper,
      lens    => "Properties.lns",
      require => Anchor['activemq::package::end'],
      notify  => Service['activemq'],
    }
  }

  class { 'activemq::service': }
}
