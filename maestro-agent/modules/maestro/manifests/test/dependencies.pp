class maestro::test::dependencies {
  # mesa-dri-drivers and fonts are required by firefox (at least) or will cause a segfault
  # usually xorg-x11-fonts* are installed, but puppet can't use wildcards
  $packages = ['firefox', 'xorg-x11-xauth', 'xorg-x11-server-utils', 'xorg-x11-server-Xvfb',
    'mesa-dri-drivers', 'xorg-x11-fonts-Type1']

  package { $packages:
    ensure => installed,
  }
}
