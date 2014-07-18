# Jenkins swarm slave `maestrodev/jenkins-slave`

A CentOS [Jenkins swarm](https://wiki.jenkins-ci.org/display/JENKINS/Swarm+Plugin) slave, installed using Puppet.

For a container with many build tools installed see `maestrodev/build-agent`

## Running

To run a Docker container customizing the different tools with your credentials

    docker run \
    -e JENKINS_USERNAME=jenkins \
    -e JENKINS_PASSWORD=jenkins \
    -e JENKINS_MASTER=http://jenkins:8080 \
    maestrodev/jenkins-slave

# Building

See `site.pp` and `common.yaml` for the Puppet configuration in each dir.

## build-agent

    # Puppet modules are checked in for Docker hub auto builds
    # gem install librarian-puppet
    # librarian-puppet install
    docker build -t maestrodev/jenkins-slave .
