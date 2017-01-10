module Events
  class PullRequest < Event
    WEEK = 7 * 24 * 60 * 60

    def process
      case
      when closed?
        update_card(:accept)
      when wip?
        add_label(:WIP)
        remove_label(:Reviewed)
      when !wip?
        remove_label(:WIP)
        update_card(:finish)
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

      def closed?
        payload.action == "closed"
      end

      def wip?
        title.include?("[WIP]")
      end

      def title
        issue.title
      end

      def update_card(status)
        return unless trello_card_id
        trello.update_card(trello_card_id, status: status)
      end

      def trello_card_id
        title[/\[Delivers #(\S+)\]/, 1]
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

      def trello
        Cp8.trello_client
      end
  end
end
