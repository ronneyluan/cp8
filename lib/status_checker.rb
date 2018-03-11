class StatusChecker
  OK = "success"
  NOT_OK = "failure"

  def initialize(issue, approvals_required: nil)
    @issue = issue
    @approvals_required = approvals_required&.to_i
  end

  def run
    return if approvals_required.blank?
    return if issue.sha.blank?

    set_status_on_github
  end

  private

    attr_reader :issue, :approvals_required

    def set_status_on_github
      github.create_status(issue.repo, issue.sha, status, context: "CP-8", description: description)
    end

    def status
      if passed?
        OK
      else
        NOT_OK
      end
    end

    def description
      if passed?
        "Approved by reviewers"
      else
        "Need at least #{approvals_required} approval(s)"
      end
    end

    def passed?
      issue.approval_count >= approvals_required
    end

    def github
      Cp8.github_client
    end
end
