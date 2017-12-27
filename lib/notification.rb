class Notification
  def self.deliver(*args)
    new.deliver(*args)
  end

  def deliver(*args)
    client.ping(*args)
  end

  private

    def client
      Cp8.chat_client
    end
end
