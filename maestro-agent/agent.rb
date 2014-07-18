require 'json'
config_file = "/var/local/maestro-agent/conf/maestro_agent.json"
config = JSON.parse File.read config_file

config['agent']['stomp']['host'] = ARGV[0]
config['agent']['stomp']['user'] = ARGV[1]
config['agent']['stomp']['passcode'] = ARGV[2]

File.open(config_file,"w") do |f|
  f.write(JSON.pretty_generate(config))
end
