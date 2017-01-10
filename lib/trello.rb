require "trello_flow/api/base"

class Trello
  def initialize(key:, token:)
    TrelloFlow::Api::Base.configure key: key, token: token
  end

  def update_card(id, status:)
    TrelloFlow::Api::Card.find(id).send(status)
  end
end
