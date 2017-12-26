class User
  BOT_LOGINS = %w(houndci-bot)
  attr_reader :login

  def self.bots
    BOT_LOGINS.map do |login|
      new(login: login)
    end
  end

  def self.from_resource(resource)
    new(resource.to_h)
  end

  def initialize(login:, avatar_url: nil, **other)
    @login = login
    @avatar_url = avatar_url
  end

  def chat_name
    "<@#{login}>"
  end

  def avatar_url(size: 16)
    @avatar_url + "&size=#{size}"
  end

  def eql?(other)
    return unless other.is_a?(User)
    login == other.login
  end

  def hash
    login.hash
  end
end
