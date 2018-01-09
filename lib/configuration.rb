class Configuration
  attr_reader :stale_issue_weeks, :review_channel

  def initialize(stale_issue_weeks: nil, review_channel: nil)
    @stale_issue_weeks = stale_issue_weeks
    @review_channel = review_channel
  end
end
