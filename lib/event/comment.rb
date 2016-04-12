class Event
  class Comment < Event
    PLUS_ONE = "👍 "
    RECYCLE = "♻️"

    def process
      case
      when body.include?(PLUS_ONE)
        add_label(:Reviewed)
      when body.include?(RECYCLE)
        remove_label(:Reviewed)
      end
    end

    private

      def body
        payload.comment.body
      end
  end
end
