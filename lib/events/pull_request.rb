module Events
  class PullRequest < Event
    WEEK = 7 * 24 * 60 * 60

    def process
      case
      when opened? && title.include?("[WIP]")
        add_label(:WIP)
      when edited? && title.include?("[WIP]")
        add_label(:WIP)
        remove_label(:Reviewed)
      when edited? && !title.include?("[WIP]")
        remove_label(:WIP)
      end
      report_stale_issues
    end

    private

      def edited?
        payload.action == "edited"
      end

      def opened?
        payload.action == "opened"
      end

      def title
        issue.title
      end

      def report_stale_issues
        stale_issues.each do |issue|
          github.add_comment(repo, issue.number, "[BEEP BOOP] Hi there!\n\nJust a reminder that this issue/PR hasn't been updated in _5 weeks_ and should probably be closed and labelled `icebox` for now.\n\nFeel free to re-open in the future if/when it becomes relevant again! :heart:")
        end
      end

      def stale_issues
        github.search_issues("repo:#{repo} is:open updated:<#{stale_pr_cutoff_date}").items
      end

      def stale_pr_cutoff_date
        (Time.now - 5 * WEEK).iso8601
      end

      def github
        Cp8.github_client
      end
  end
end
