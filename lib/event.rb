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
      raise "OCTOKIT_ACCESS_TOKEN env variable not set" unless ENV["OCTOKIT_ACCESS_TOKEN"]
      @github ||= Octokit::Client.new
    end
end
