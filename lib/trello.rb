require "cp8_cli/trello/base"

class Trello
  def initialize(key:, token:)
    Cp8Cli::Trello::Base.configure key: key, token: token
  end

  def update_card(id, status:)
    find_card(id).send(status)
  end

  def attach(id, url:)
    find_card(id).attach(url: url)
  end

  private

    def find_card(id)
      Cp8Cli::Trello::Card.find(id)
    end
end
