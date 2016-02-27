require "bundler"

Bundler.require :default, ENV["RACK_ENV"].to_sym

require "sinatra/reloader" if development?

# Routes
#
get "/" do
  "Blank Sinatra"
end
