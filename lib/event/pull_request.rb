class Event
  class PullRequest < Event
    def process
      case
      when opened? && title.include?("[WIP]")
        add_label(:WIP)
      end
    end

    private

      def opened?
        payload.action == "opened"
      end

      def title
        issue.title
      end
  end
end
