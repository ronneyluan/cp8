require "notifications/review_request_notification"

class RecycleNotification < ReviewRequestNotification
  def initialize(issue:, comment:)
    super(
      issue: issue,
      action: ":recycle: Review changes",
      link: comment.html_url,
      mentions: issue.peer_reviewers.map(&:chat_name)
    )
  end
end
