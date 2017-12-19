class Comment
  RECYCLE = ["♻️", ":recycle:"]

  def initialize(body:, **other)
    @body = body
  end

  def recycle_request?
    RECYCLE.any? { |word| body.include?(word) }
  end

  private

    attr_reader :body
end
