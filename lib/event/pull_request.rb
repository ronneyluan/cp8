class Event
  class PullRequest < Event
    def process
      case
      when title.include?("[WIP]")
        add_label(:WIP)
      end
    end

    private

      def title
        payload.pull_request.title
      end

      def number
        payload.pull_request.number
      end
  end
end
