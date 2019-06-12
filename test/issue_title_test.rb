require "test_helper"

class IssueTitleTest < Minitest::Test
  def test_tags
    title = IssueTitle.new("[WIP] Still working on it")

    assert_equal [:wip], title.tags
  end

  def test_title_escaping
    title = IssueTitle.new("With <div>HTML</div> & ampersand")

    assert_equal title.to_s, "With &lt;div&gt;HTML&lt;/div&gt; &amp; ampersand"
  end
end
