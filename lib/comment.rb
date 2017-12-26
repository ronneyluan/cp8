class Comment
  RECYCLE = ["♻️", ":recycle:"]

  attr_reader :body

  def initialize(body:, **other)
    @body = body
  end

  def recycle_request?
    RECYCLE.any? { |word| body.include?(word) }
  end
end
