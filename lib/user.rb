class User
  attr_reader :login

  def self.from_json(attributes = {})
    new(attributes.symbolize_keys)
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

  private
end
