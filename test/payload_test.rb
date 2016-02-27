require "test_helper"

class PayloadTest < Minitest::Test
  def test_it_does_something_useful
    json = File.read File.expand_path("../fixtures/comment.json", __FILE__)
    Payload.new_from_json(json).process
  end
end
