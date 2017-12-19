class RecycleNotification
  DEFAULT_CHANNEL = "#reviews"
  DEFAULT_USERNAME = "CP-8"

  def initialize(issue:, channel:)
    @issue = issue
    @channel = channel || DEFAULT_CHANNEL
  end

  def deliver
    client.ping(message, channel: channel, username: DEFAULT_USERNAME)
  end

  private

    attr_reader :issue, :channel

    def message
      "#{mentions} :recycle: please #{issue.html_url}"
    end

    def mentions
      issue.reviewers.map(&:chat_name).join(", ")
    end

    def client
      Cp8.chat_client
    end
end
