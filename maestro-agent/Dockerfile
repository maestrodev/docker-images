FROM maestrodev/build-agent

MAINTAINER Carlos Sanchez <carlos@apache.org>

ADD site.pp /etc/puppet/manifests/
ADD common.yaml /var/lib/hiera/common.yaml

RUN puppet apply /etc/puppet/manifests/site.pp --verbose --detailed-exitcodes || [ $? -eq 2 ]

CMD su maestro_agent -c '/bin/sh /cmd.sh'
