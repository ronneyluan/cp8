class IssueCloser
  WEEK = 7 * 24 * 60 * 60

  def initialize(repo, weeks: 4)
    @repo = repo
    @weeks = weeks
  end

  def run
    stale_issues.each do |issue|
      github.close_issue(issue.repo, issue.number)
      github.add_comment(issue.repo, issue.number, "[BEEP BOOP] Hi there!\n\nThis issue/PR hasn't been updated in _a month_ so am closing it for now.\n\nFeel free to re-open in the future if/when it becomes relevant again! :heart:")
      Label.new(:Icebox).add_to(issue)
    end
  end

  private

    attr_reader :repo, :weeks

    def stale_issues
      stale_issue_data.map do |data|
        Issue.new(data.to_h.merge(repo: repo))
      end
    end

    def stale_issue_data
      github.search_issues("repo:#{repo} is:open updated:<#{stale_pr_cutoff_date}").items
    end

    def stale_pr_cutoff_date
      (Time.now - weeks * WEEK).iso8601
    end

    def github
      Cp8.github_client
    end
end
