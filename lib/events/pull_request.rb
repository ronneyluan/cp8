module Events
  class PullRequest < Event
    WEEK = 7 * 24 * 60 * 60

    def process
      case
      when closed?
        update_cards(:accept)
      when wip?
        add_label(:WIP)
        remove_label(:Reviewed)
      when !wip?
        remove_label(:WIP)
        update_cards(:finish)
      end

      attach_to_cards if opened?
      report_stale_issues
    end

    private

      def opened?
        payload.action == "opened"
      end

      def closed?
        payload.pull_request.state == "closed"
      end

      def prefixes
        tag_matches[1].to_s.split(" ")
      end

      def tag_matches
        title.match(/^\[(.+)\]/) || []
      end

      def wip?
        prefixes.include?("WIP")
      end

      def title
        issue.title
      end

      def url
        issue.html_url
      end

      def attach_to_cards
        card_ids.each do |id|
          trello.attach(id, url: url)
        end
      end

      def update_cards(status)
        card_ids.each do |id|
          trello.update_card(id, status: status)
        end
      end

      def card_ids
        delivers_meta_info.scan(/(?:#(\w+))/).flatten
      end

      def delivers_meta_info
        title[/\[Delivers.+\]/] || ""
      end

      def report_stale_issues
        stale_issues.each do |issue|
          github.add_comment(repo, issue.number, "[BEEP BOOP] Hi there!\n\nJust a reminder that this issue/PR hasn't been updated in _a month_ and should probably be closed and labelled `icebox` for now.\n\nFeel free to re-open in the future if/when it becomes relevant again! :heart:")
        end
      end

      def stale_issues
        github.search_issues("repo:#{repo} is:open updated:<#{stale_pr_cutoff_date}").items
      end

      def stale_pr_cutoff_date
        (Time.now - 4 * WEEK).iso8601
      end

      def github
        Cp8.github_client
      end

      def trello
        Cp8.trello_client
      end
  end
end
