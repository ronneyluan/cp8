require "json"
require "issue"

class Payload < Hashie::Mash
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def issue
    Issue.new(super || pull_request)
  end

  def repo
    repository.full_name
  end
end
