# Maestro agent `maestrodev/agent`

An extension to the build agent `maestrodev/build-agent` that includes the Maestro Agent service for Maestro users.

    docker run \
    -e JENKINS_USERNAME=jenkins \
    -e JENKINS_PASSWORD=jenkins \
    -e JENKINS_MASTER=http://jenkins:8080 \
    -e RUBYGEMS_API_KEY=xxxxx \
    -e GEMINABOX=https://xxx:yyy@gems.acme.com \
    -e PUPPETFORGE_USERNAME=john \
    -e PUPPETFORGE_PASSWORD=doe \
    -e STOMP_HOST=maestro \
    -e STOMP_USER=maestro \
    -e STOMP_PASSCODE=maestro \
    maestrodev/maestro-agent

# Building

Edit credentials in common.yaml and build

    docker build -t maestrodev/maestro-agent .
