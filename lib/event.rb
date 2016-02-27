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
      Cp8.github_client
    end
end
