#!/bin/sh

ruby /agent.rb $STOMP_HOST $STOMP_USER $STOMP_PASSCODE
/sbin/service maestro-agent console && /bin/sh /cmd.sh
