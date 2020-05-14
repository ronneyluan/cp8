require "notifications/review_request_notification"

class ReadyForReviewNotification < ReviewRequestNotification
  def initialize(issue:, small_pr_addition_limit:)
    super(
      issue: issue,
      icon: :mag
    )
    @small_pr_addition_limit = small_pr_addition_limit
  end

  private

    attr_reader :small_pr_addition_limit

    def action
      if issue.small?(small_pr_addition_limit)
        "Small PR"
      else
        "New PR"
      end
    end

    def mentions
      if issue.small?(small_pr_addition_limit)
        requested_reviewers
      else
        []
      end
    end

    def requested_reviewers
      @_requested_reviewers ||= issue.requested_reviewers.map(&:chat_name)
    end
end
