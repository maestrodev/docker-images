notify { "using MAESTRODEV_USERNAME=$maestrodev_username": }

class { 'maestro::yumrepo':
  username => $maestrodev_username,
  password => $maestrodev_password,
}

# Java
class { 'java': package => 'java-1.6.0-openjdk-devel' }

firewall { '900 enable ssh':
  action => accept,
  dport => "22",
  proto => "tcp",
}
