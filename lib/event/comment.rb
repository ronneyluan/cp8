class Event
  class Comment < Event

    def process
      case
      when body.include?(":+1:")
        add_reviewed_label
      when body.include?(":recycle:")
        remove_reviewed_label
      end
    end

    private

      def add_reviewed_label
        add_label(:Reviewed)
      end

      def remove_reviewed_label
        remove_label(:Reviewed)
      end

      def body
        payload.comment.body
      end

      def number
        payload.issue.number
      end
  end
end
