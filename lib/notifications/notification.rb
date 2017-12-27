class Notification
  def initialize(issue:, action:, mentions: nil, link: nil, channel: nil)
    @issue = issue
    @action = action
    @mentions = mentions.presence || ["<!here>"]
    @link = link || issue.html_url
    @channel = channel
  end

  def deliver
    client.ping(
      text: mentions.join(", "),
      attachments: [attachment],
      channel: channel
    )
  end

  private

    attr_reader :issue, :action, :mentions, :link, :channel

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

    def client
      Cp8.chat_client
    end
end
