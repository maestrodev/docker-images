# This class is used to install the Sonar Ant task library.
#
# ==Parameters
#
# [version]  The version to install.
class ant::tasks::sonar($version = '1.2') {

  ant::lib { 'sonar-ant-task':
    source_url => "http://repository.codehaus.org/org/codehaus/sonar-plugins/sonar-ant-task/${version}/sonar-ant-task-${version}.jar",
    version    => $version,
  }

}
