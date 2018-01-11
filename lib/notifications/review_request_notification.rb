require "notifications/notification"

class ReviewRequestNotification < Notification
  def initialize(issue:, icon:, action:, mentions: nil, link: nil)
    @issue = issue
    @icon = icon
    @action = action
    @mentions = mentions.presence || ["<!here>"]
    @link = link || issue.html_url
  end

  def text
    mentions.join(", ") + " :#{icon}: #{action}"
  end

  def attachments
    [attachment]
  end

  private

    attr_reader :issue, :icon, :action, :mentions, :link

    def attachment
      {
        author_name: issue.user.login,
        author_icon: issue.user.avatar_url,
        fields: [issue_field, changes_field]
      }
    end

    def issue_field
      {
        title: "Pull Request",
        value: "<#{link}|##{issue.number} #{issue.title}>",
        short: true
      }
    end

    def changes_field
      {
        title: "Diff",
        value: "+#{issue.additions} / -#{issue.deletions}",
        short: true
      }
    end
end
