require "json"
require "issue"
require "comment"

class Payload
  def self.new_from_json(raw_json)
    new JSON.parse(raw_json)
  end

  def initialize(data = {})
    @data = data.deep_symbolize_keys
  end

  def issue
    @_issue ||= Issue.new(issue_params)
  end

  def repo
    data[:repository][:full_name]
  end

  def sender_id
    data[:sender][:id]
  end

  def unwip_action?
    action == "edited" && !issue.wip? && previous_title.include?(Issue::WIP_TAG)
  end

  def recycle_request?
    comment&.recycle_request?
  end

  def pull_request?
    data[:pull_request].present?
  end

  def action
    data[:action]
  end

  def comment
    return unless comment_params

    Comment.new(comment_params)
  end

  private

    attr_reader :data

    def issue_params
      issue_or_pull_request_data.merge(repo: repo)
    end

    def comment_params
      data[:comment]
    end

    def issue_or_pull_request_data
      data[:issue] || data[:pull_request]
    end

    def previous_title
      data.fetch(:changes, {}).fetch(:title, {}).fetch(:from, {}) || ""
    end
end
