require "issue_closer"
require "labeler"

class Processor
  def initialize(payload)
    @payload = payload
  end

  def process
    if payload.pull_request?
      Events::PullRequestUpdate.new(payload).process
    end

    add_labels
    close_stale_issues
  end

  private

    attr_reader :payload

    def add_labels
      Labeler.new(repo, payload.issue).run
    end

    def close_stale_issues
      return if event_triggered_by_cp8?

      IssueCloser.new(repo).run
    end

    def event_triggered_by_cp8?
      current_user.id == payload.sender&.id
    end

    def current_user
      github.user
    end

    def repo
      payload.repo
    end

    def github
      Cp8.github_client
    end
end
