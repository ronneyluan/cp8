class Comment
  RECYCLE = ["♻️", ":recycle:"]

  attr_reader :body, :html_url

  def initialize(body:, html_url:, **other)
    @body = body
    @html_url = html_url
  end

  def recycle_request?
    RECYCLE.any? { |word| body.include?(word) }
  end
end
