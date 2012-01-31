require "./Domrobot"
require "yaml"


addr = "api.domrobot.com"
user = "tschul"
pass = "Markus1979"

domrobot = INWX::Domrobot.new(addr)

result = domrobot.login(user,pass)
puts YAML::dump(result)

object = "domain"
method = "check"

params = { :domain => "mydomain.com" }

result = domrobot.call(object, method, params)

puts YAML::dump(result)

