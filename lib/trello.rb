require "trello_flow/api/base"

class Trello
  def initialize(key:, token:)
    TrelloFlow::Api::Base.configure key: key, token: token
  end

  def finish_card(id)
    TrelloFlow::Api::Card.find(id).finish
  end
end
