require "json"

class Payload < Hashie::Mash
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def process
    if pull_request?
      Events::PullRequest.new(self).process
    end
  end
end
