require "test_helper"

class IssueTest < Minitest::Test
  def setup
    Cp8.github_client = github
  end

  def test_multiple_approvals_for_same_user
    github.expects(:pull_request_reviews).with("balvig/cp-8", 1).once.returns(
      [
        { state: "approved", user: { login: "reviewer" } },
        { state: "changes_requested", user: { login: "reviewer" } },
        { state: "approved", user: { login: "reviewer" } }
      ]
    )

    assert_equal 1, issue.approval_count
  end

  def test_last_review_was_changes_requested
    github.expects(:pull_request_reviews).with("balvig/cp-8", 1).once.returns(
      [
        { state: "approved", user: { login: "reviewer" } },
        { state: "approved", user: { login: "reviewer" } },
        { state: "changes_requested", user: { login: "reviewer" } }
      ]
    )

    assert_equal 0, issue.approval_count
  end

  private

    def issue
      @_issue ||= Issue.new(number: 1, repo: "balvig/cp-8")
    end

    def github
      @_github ||= stub
    end
end

