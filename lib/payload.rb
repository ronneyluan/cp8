require "json"

class Payload < Hashie::Mash
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def process
    Event::PullRequest.new(self).process if pull_request?
    Event::Comment.new(self).process if comment? && issue.pull_request?
  end
end
