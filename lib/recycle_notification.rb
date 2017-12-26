require "notification"

class RecycleNotification
  def initialize(issue:, comment_body:)
    @issue = issue
    @comment_body = comment_body
  end

  def deliver
    Notification.new(
      issue: issue,
      action: ":recycle: Review changes",
      mentions: mentions
    ).deliver
  end

  private

    attr_reader :issue, :comment_body

    def mentions
      issue.reviewers.map(&:chat_name)
    end
end
