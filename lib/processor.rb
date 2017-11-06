class Processor
  def initialize(payload)
    @payload = payload
  end

  def process
    if payload.pull_request?
      Events::PullRequestUpdate.new(payload).process
    elsif payload.issue?
      Events::IssueUpdate.new(payload).process
    end
  end

  private

    attr_reader :payload
end
