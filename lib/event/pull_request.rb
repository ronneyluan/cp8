class Event
  class PullRequest < Event
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
  end
end
