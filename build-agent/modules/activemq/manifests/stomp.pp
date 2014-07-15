# Configure ActiveMQ to use Stomp connector
class activemq::stomp( $port = 61613 ){

  augeas { 'activemq-stomp':
    changes => [
      'set beans/broker/transportConnectors/transportConnector[last()+1]/#attribute/name stomp+nio',
      "set beans/broker/transportConnectors/transportConnector[last()]/#attribute/uri stomp+nio://0.0.0.0:${port}?transport.closeAsync=false",
    ],
    incl    => "${activemq::home}/activemq/conf/activemq.xml",
    lens    => 'Xml.lns',
    require => Anchor['activemq::package::end'],
    notify  => Service['activemq'],
    onlyif  => 'match beans/broker/transportConnectors/transportConnector[#attribute/name = "stomp+nio"] size == 0',
  }
}
