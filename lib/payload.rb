require "json"

class Payload < Hashie::Mash
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def process
    Event::PullRequest.new(self).process if respond_to?(:pull_request)
    Event::Comment.new(self).process if respond_to?(:comment)
  end
end
