class User
  def initialize(login:)
    @login = login
  end

  def chat_name
    "<@#{login}>"
  end

  private

    attr_reader :login
end
