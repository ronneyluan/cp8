lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bundler"

Bundler.require :default, ENV["RACK_ENV"].to_sym

require "cp8"

post "/payload" do
  Payload.new_from_json(request.body.read).process
  "Done!"
end
