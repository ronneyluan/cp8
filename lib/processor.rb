require "card_updater"
require "issue_closer"
require "labeler"
require "recycle_notification"

class Processor
  def initialize(payload, config: nil)
    @payload = payload
    @config = config || {}
  end

  def process
    return if event_triggered_by_cp8?

    notify_reviewers if recycle_request?
    update_trello_cards # backwards compatibility for now
    add_labels
    close_stale_issues
  end

  private

    attr_reader :payload, :config

    def update_trello_cards
      CardUpdater.new(payload).run
    end

    def add_labels
      Labeler.new(payload.issue).run
    end

    def close_stale_issues
      IssueCloser.new(repo, weeks: config[:stale_issue_weeks]).run
    end

    def notify_reviewers
      RecycleNotification.new(
        issue: payload.issue,
        channel: config[:chat_channel]
      ).deliver
    end

    def event_triggered_by_cp8?
      current_user.id == payload.sender_id
    end

    def current_user
      github.user
    end

    def repo
      payload.repo
    end

    def recycle_request?
      payload.comment&.recycle_request?
    end

    def github
      Cp8.github_client
    end
end
