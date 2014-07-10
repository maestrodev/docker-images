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

# jenkins slave
JAR=`ls -1 $HOME/swarm-client-*.jar | tail -n 1`
java -jar $JAR -username $JENKINS_USERNAME -password $JENKINS_PASSWORD -master $JENKINS_MASTER -fsroot $HOME
