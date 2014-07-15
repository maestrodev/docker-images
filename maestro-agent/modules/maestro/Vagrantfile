Vagrant::Config.run do |config|
  # specify our basebox
  config.vm.box = "CentOS-6.4-x86_64-minimal"
  config.vm.box_url = "https://repo.maestrodev.com/archiva/repository/public-releases/com/maestrodev/vagrant/CentOS/6.4/CentOS-6.4-x86_64-minimal.box"

  # use UTC clock
  config.vm.customize ["modifyvm", :id, "--rtcuseutc", "on"]

  # require the correct environment variable
  abort "MAESTRODEV_USERNAME must be set" unless ENV['MAESTRODEV_USERNAME']
  abort "MAESTRODEV_PASSWORD must be set" unless ENV['MAESTRODEV_PASSWORD']
  
  # use local puppetlib modules and this module as /etc/puppet
  config.vm.share_folder "dep-modules", "/etc/puppet/modules", "./spec/fixtures/modules", :create => true, :owner => "puppet", :group => "puppet"
  config.vm.share_folder "this-module", "/etc/puppet/modules/maestro", ".", :create => true, :owner => "puppet", :group => "puppet"

  # install the extra modules needed
  config.vm.provision :shell, :inline => "test -d /etc/puppet/modules/java || puppet module install puppetlabs/java -v 0.3.0"
  config.vm.provision :shell, :inline => "test -d /etc/puppet/modules/rvm || puppet module install maestrodev/rvm -v 1.1.2"

  # map the puppet graphs directory to local, so we can easily check them out in ./graphs
  config.vm.share_folder "puppet-graphs", "/var/lib/puppet/state/graphs", "graphs", :create => true, :owner => "puppet", :group => "puppet"

  # allow additional puppet options to be passed in (e.g. --graph, --debug, etc.)
  # note: splitting args is fragile and doesn't support spaces in args, but for now it works for what we need
  puppet_options = ["--modulepath", "/etc/puppet/modules", (ENV['PUPPET_OPTIONS']||"").split(/ /)];

  # agent test VM
  config.vm.define :agent do |config|
    config.vm.host_name = "agent.acme.com"

    # this will let us connect to the JMX port locally (note: if you change this, you must change in agent.pp as well)
    config.vm.network  :hostonly, "10.42.42.50"

    config.vm.customize ["modifyvm", :id, "--name", "agent"] # name for VirtualBox GUI
    #config.vm.customize ["modifyvm", :id, "--memory", 1024]

    config.vm.provision :puppet do |puppet|
      puppet.options = puppet_options
      puppet.facter = { "maestrodev_username" => ENV['MAESTRODEV_USERNAME'], "maestrodev_password" => ENV['MAESTRODEV_PASSWORD'] }
      puppet.manifests_path = "tests"
      puppet.manifest_file  = "agent.pp"
    end
  end

  # maestro test VM
  config.vm.define :maestro do |config|
    config.vm.provision :shell, :inline => "test -d /etc/puppet/modules/activemq || puppet module install maestrodev/activemq"

    config.vm.host_name = "maestro.acme.com"

    # this will let us connect to the JMX port locally (note: if you change this, you must change in agent.pp as well)
    config.vm.network  :hostonly, "10.42.42.51"

    config.vm.customize ["modifyvm", :id, "--name", "maestro"] # name for VirtualBox GUI
    #config.vm.customize ["modifyvm", :id, "--memory", 1024]

    config.vm.provision :puppet do |puppet|
      puppet.options = puppet_options
      puppet.facter = { "maestrodev_username" => ENV['MAESTRODEV_USERNAME'], "maestrodev_password" => ENV['MAESTRODEV_PASSWORD'] }
      puppet.manifests_path = "tests"
      puppet.manifest_file  = "maestro.pp"
    end
  end
end
