# Build agent `maestrodev/build-agent`

A preinstalled CentOS build agent running Jenkins swarm slave with typical build software, installed using Puppet.

* Java
* Ant
* Maven
* RVM (with 1.9, 2.0, 2.1, JRuby)
* Git
* Svn

## Running

To run a Docker container customizing the different tools with your credentials

    docker run \
    -e JENKINS_USERNAME=jenkins \
    -e JENKINS_PASSWORD=jenkins \
    -e JENKINS_MASTER=http://jenkins:8080 \
    -e RUBYGEMS_API_KEY=xxxxx \
    -e GEMINABOX=https://xxx:yyy@gems.acme.com \
    -e PUPPETFORGE_USERNAME=john \
    -e PUPPETFORGE_PASSWORD=doe \
    maestrodev/build-agent

## Jenkins

Jenkins master will be autodiscovered by Jenkins Swarm, but JENKINS_MASTER environment variable can be set to the master url, as well as JENKINS_USERNAME and JENKINS_PASSWORD if needed.

## Rubygems

If you are deploying to rubygems.org you can set RUBYGEMS_API_KEY, or if deploying to a private geminabox repo its url can be set with the GEMINABOX envvar.

## Puppet Blacksmith

Setting PUPPETFORGE_USERNAME and PUPPETFORGE_PASSWORD will configure Puppet Blacksmith to deploy to the Puppet Forge.


# Building

See `site.pp` and `common.yaml` for the Puppet configuration in each dir.

## build-agent

    # Puppet modules are checked in for Docker hub auto builds
    # gem install librarian-puppet
    # librarian-puppet install
    docker build -t maestrodev/build-agent .
