class IssueCloser
  WEEK = 7 * 24 * 60 * 60

  def initialize(repo, weeks: 4)
    @repo = repo
    @weeks = weeks
  end

  def run
    stale_issues.each do |issue|
      github.close_issue(repo, issue.number)
      github.add_comment(repo, issue.number, "[BEEP BOOP] Hi there!\n\nThis issue/PR hasn't been updated in _a month_ so am closing it for now.\n\nFeel free to re-open in the future if/when it becomes relevant again! :heart:")
      Label.new(repo, :Icebox).add_to(issue)
    end
  end

  private

    attr_reader :repo, :weeks

    def stale_issues
      github.search_issues("repo:#{repo} is:open updated:<#{stale_pr_cutoff_date}").items
    end

    def stale_pr_cutoff_date
      (Time.now - weeks * WEEK).iso8601
    end

    def github
      Cp8.github_client
    end
end
