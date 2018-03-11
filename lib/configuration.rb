class Configuration
  attr_reader :stale_issue_weeks, :review_channel, :approvals_required

  def initialize(stale_issue_weeks: nil, review_channel: nil, approvals_required: nil)
    @stale_issue_weeks = stale_issue_weeks
    @review_channel = review_channel
    @approvals_required = approvals_required
  end
end
