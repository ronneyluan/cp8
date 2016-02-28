require "json"

class Payload < Hashie::Mash
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def process
    case
    when pull_request?
      Event::PullRequest.new(self).process
    when comment? && issue.pull_request?
      Event::Comment.new(self).process
    end
  end
end
