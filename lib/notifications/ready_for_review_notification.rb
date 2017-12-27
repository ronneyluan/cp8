require "notifications/review_request_notification"

class ReadyForReviewNotification
  def initialize(issue:)
    @issue = issue
  end

  def deliver
    ReviewRequestNotification.new(
      issue: issue,
      action: ":mag: Review"
    ).deliver
  end

  private

    attr_reader :issue
end
