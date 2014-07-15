

node default {
  include jenkins

  package {
    'git' :
      ensure   => latest,
      provider => jenkinsplugin;

    'greenballs' :
      ensure   => disabled,
      provider => jenkinsplugin;

    'cvs' :
      ensure   => absent,
      provider => jenkinsplugin;
  }

}
