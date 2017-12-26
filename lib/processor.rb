require "card_updater"
require "issue_closer"
require "labeler"
require "recycle_notification"
require "unwip_notification"

class Processor
  def initialize(payload, config: nil)
    @payload = payload
    @config = config || {}
    @logs = []
  end

  def process
    return if event_triggered_by_cp8?

    notify_unwip if unwip_action?
    notify_recycle if recycle_request?
    update_trello_cards # backwards compatibility for now
    add_labels
    close_stale_issues
    logs.join("\n")
  end

  private

    attr_reader :payload, :config, :logs

    def log(msg)
      logs << msg
    end

    def notify_unwip
      log "Notifying unwip"

      UnwipNotification.new(issue: payload.issue).deliver
    end

    def notify_recycle
      log "Notifying recycle request"

      RecycleNotification.new(
        issue: payload.issue,
        comment_body: payload.comment.body,
      ).deliver
    end

    def update_trello_cards
      log "Updating trello cards"
      CardUpdater.new(payload).run
    end

    def add_labels
      log "Updating labels"
      Labeler.new(payload.issue).run
    end

    def close_stale_issues
      log "Closing stale issues"
      IssueCloser.new(repo, weeks: config[:stale_issue_weeks]).run
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
      payload.recycle_request?
    end

    def unwip_action?
      payload.unwip_action?
    end

    def github
      Cp8.github_client
    end
end
