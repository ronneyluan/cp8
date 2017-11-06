lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "bundler"

Bundler.require :default, ENV["RACK_ENV"].to_sym

require "cp8"

set :show_exceptions, false

post "/payload" do
  payload = Payload.new_from_json(request.body.read)
  Processor.new(payload).process
  "Done!"
end

error 500 do
  error = env["sinatra.error"]
  "#{error.class}: #{error.message}"
end
