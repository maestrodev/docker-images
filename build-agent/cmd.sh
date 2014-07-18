#!/bin/sh

# rubygems
cat << EOF > $HOME/.gem/credentials
---
:rubygems_api_key: $RUBYGEMS_API_KEY
EOF

# geminabox
cat << EOF > $HOME/.gem/geminabox
---
:host: $GEMINABOX
EOF

# pupet forge blacksmith
cat << EOF > $HOME/.puppetforge.yml
---
forge: 'https://forge.puppetlabs.com'
username: '$PUPPETFORGE_USERNAME'
password: '$PUPPETFORGE_PASSWORD'
EOF

# jenkins swarm slave
JAR=`ls -1 $HOME/swarm-client-*.jar | tail -n 1`

PARAMS=""
if [ ! -z "$JENKINS_USERNAME" ]; then
  PARAMS="$PARAMS -username $JENKINS_USERNAME"
fi
if [ ! -z "$JENKINS_PASSWORD" ]; then
  PARAMS="$PARAMS -password $JENKINS_PASSWORD"
fi
if [ ! -z "$JENKINS_MASTER" ]; then
  PARAMS="$PARAMS -master $JENKINS_MASTER"
fi
java -jar $JAR $PARAMS -fsroot $HOME
