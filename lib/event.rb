class Event
  def initialize(payload)
    @payload = payload
  end

  def process
    raise "Not implemented"
  end

  private

    def repo
      @payload.repository.full_name
    end

    def github
      @github ||= Octokit::Client.new(access_token: "20aab592dacbe7dc6cc30635f9e0b39d56b1634c")
    end
end
