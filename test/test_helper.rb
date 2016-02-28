ENV["RACK_ENV"] = "test"
$LOAD_PATH.unshift File.expand_path("../..", __FILE__)
require "app"
require "minitest/autorun"
require "minitest/reporters"
require "mocha/mini_test"

# Pretty colors
Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new
