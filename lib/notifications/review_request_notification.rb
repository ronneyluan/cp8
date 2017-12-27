require "notification"

class ReviewRequestNotification
  def initialize(issue:, action:, mentions: nil, link: nil)
    @issue = issue
    @action = action
    @mentions = mentions.presence || ["<!here>"]
    @link = link || issue.html_url
  end

  def deliver
    Notification.deliver(
      text: mentions.join(", "),
      attachments: [attachment]
    )
  end

  private

    attr_reader :issue, :action, :mentions, :link

    def attachment
      {
        author_name: issue.user.login,
        author_icon: issue.user.avatar_url,
        fields: [action_field, issue_field, changes_field]
      }
    end

    def action_field
      {
        title: "Action Required",
        value: action
      }
    end

    def changes_field
      {
        title: "Diff",
        value: "+#{issue.additions} / -#{issue.deletions}",
        short: true
      }
    end

    def issue_field
      {
        title: "Pull Request",
        value: "<#{link}|##{issue.number} #{issue.title}>",
        short: true
      }
    end
end
