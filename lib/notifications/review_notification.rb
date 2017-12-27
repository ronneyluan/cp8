require "notifications/notification"

class ReviewNotification
  def initialize(issue:, review:)
    @issue = issue
    @review = review
  end

  def deliver
    client.ping(text: text)
  end

  private

    attr_reader :review, :issue

    def text
      ":#{icon}: <#{issue.html_url}|##{issue.number} #{action}> _(cc #{issue.user.chat_name})_"
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
        "requires changes"
      end
    end

    def client
      Cp8.chat_client
    end
end
