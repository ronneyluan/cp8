class Notifier
  def initialize(channel: nil)
    @channel = channel
  end

  def deliver(notification)
    return unless channel

    client.ping(
      text: notification.text,
      attachments: notification.attachments,
      fallback: notification.fallback,
      channel: channel
    )
  end

  private

    attr_reader :channel

    def client
      Cp8.chat_client
    end
end
