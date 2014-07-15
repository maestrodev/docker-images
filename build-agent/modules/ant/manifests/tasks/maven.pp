# This class is used to install the Apache Maven Ant task library.
#
# ==Parameters
#
# [version]  The version to install.
class ant::tasks::maven($version = '2.1.3') {

  ant::lib { 'maven-ant-tasks':
    source_url => "http://archive.apache.org/dist/maven/binaries/maven-ant-tasks-${version}.jar",
    version    => $version
  }

}
