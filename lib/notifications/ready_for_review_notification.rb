require "notifications/review_request_notification"

class ReadyForReviewNotification < ReviewRequestNotification
  def initialize(issue:)
    super(
      issue: issue,
      icon: :mag,
      action: "Review"
    )
  end
end
