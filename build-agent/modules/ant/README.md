puppet-ant
==========

Puppet module for installing Ant and/or Ivy from the Apache Software
Foundation.

To install ant, simply include the ant class. You can also specify a particular
version like so:

    class { 'ant':
      version => 'x.y.z',
    }
    
This module also lets you install the Ivy dependency management tool. To install Ivy,
simply include the ant::ivy class. You can also specify a particular version like so:

    class { 'ant::ivy':
      version => 'x.y.z',
    }

You can use this module to install antlibs. Here is an example that installs the Maven ant tasks.

    ant::lib{'maven-ant-tasks':
      source_url => 'http://archive.apache.org/dist/maven/binaries/maven-ant-tasks-2.1.3.jar',
      version => '2.1.3'
    }

This will download the maven ant tasks jar file from the specified URL and place the 
maven-ant-tasks-2.1.3.jar file under the Ant lib directory.

License
-------
    Copyright 2011-2013 MaestroDev

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

