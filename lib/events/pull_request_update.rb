module Events
  class PullRequestUpdate < IssueUpdate
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
      super
    end

    private

      def opened?
        payload.action == "opened"
      end

      def closed?
        payload.pull_request.state == "closed"
      end

      def wip?
        title_tags.include?("WIP")
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

      def trello
        Cp8.trello_client
      end
  end
end
