require "json"
require "issue"

class Payload
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def initialize(data = {})
    @data = data.deep_symbolize_keys
  end

  def issue
    Issue.new (data[:issue] || data[:pull_request]).deep_symbolize_keys
  end

  def repo
    data[:repository][:full_name]
  end

  def sender_id
    data[:sender][:id]
  end

  def pull_request?
    data[:pull_request].present?
  end

  def action
    data[:action]

  end

  private

    attr_reader :data
end
