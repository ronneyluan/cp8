require "trello_flow/api/base"

class Trello
  def initialize(key:, token:)
    TrelloFlow::Api::Base.configure key: key, token: token
  end

  def update_card(id, status:)
    find_card(id).send(status)
  end

  def attach(id, url:)
    find_card(id).attach(url: url)
  end

  private

    def find_card(id)
      TrelloFlow::Api::Card.find(id)
    end
end
