require "notifications/notification"

class ReviewCompleteNotification < Notification
  def initialize(issue:, review:)
    @issue = issue
    @review = review
  end

  def text
    ":#{icon}: <#{link}|##{issue.number} #{action}> by #{review.user.login} _(cc #{issue.user.chat_name})_"
  end

  private

    attr_reader :review, :issue

    def link
      review.html_url
    end

    def icon
      if review.approved?
        :white_check_mark
      else
        :x
      end
    end

    def action
      if review.approved?
        "was approved"
      else
        "changes required"
      end
    end
end
