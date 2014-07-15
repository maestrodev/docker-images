puppet-statsd
=============

Manage Statsd with Puppet

Synopsis
--------

    class { 'statsd':
      graphiteserver   => 'my.graphite.server',
      flushinterval    => 1000, # flush every second
      percentthreshold => [75, 90, 99],
      address          => '10.20.1.2',
      listenport       => 2158,
      provider         => npm,
    }

Notes
-----

To ensure that you have a fairly recent version of statsd, it's recommended
that you install statds via npm. The most recent version of statds in Debian
Sid is 0.0.2, which is so old that the current documentation doesn't even
remotely apply.

Contributors
------------

  * Thanks to Ben Hughes (ben@puppetlabs.com) for initial implementation
