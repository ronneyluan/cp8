class Review
  def initialize(state:, **other)
    @state = state
  end

  def approved?
    state == "approved"
  end

  def changes_requested?
    state == "changes_requested"
  end

  def decisive?
    approved? || changes_requested?
  end

  private

    attr_reader :state
end
