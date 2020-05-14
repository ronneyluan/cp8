require "notifications/review_request_notification"

class ReadyForReviewNotification < ReviewRequestNotification
  def initialize(issue:, mention_threshold:)
    super(
      issue: issue,
      icon: :mag
    )
    @mention_threshold = mention_threshold
  end

  private

    attr_reader :mention_threshold

    def action
      if issue.small?(mention_threshold)
        "Small PR"
      else
        "New PR"
      end
    end

    def mentions
      if issue.small?(mention_threshold)
        requested_reviewers
      else
        []
      end
    end

    def requested_reviewers
      @_requested_reviewers ||= issue.requested_reviewers.map(&:chat_name)
    end
end
