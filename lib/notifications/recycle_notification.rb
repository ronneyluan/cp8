require "notifications/review_request_notification"

class RecycleNotification
  def initialize(issue:, comment:)
    @issue = issue
    @comment = comment
  end

  def deliver
    ReviewRequestNotification.new(
      issue: issue,
      action: ":recycle: Review changes",
      link: comment.html_url,
      mentions: mentions
    ).deliver
  end

  private

    attr_reader :issue, :comment

    def mentions
      issue.peer_reviewers.map(&:chat_name)
    end
end
