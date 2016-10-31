require "json"

class Payload < Hashie::Mash
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def process
    case
    when review?
      Events::Review.new(self).process
    when pull_request?
      Events::PullRequest.new(self).process
    when comment? && issue.pull_request?
      Events::Comment.new(self).process
    end
  end
end
