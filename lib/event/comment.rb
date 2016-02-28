class Event
  class Comment < Event
    def process
      case
      when body.include?(":+1:")
        add_label(:Reviewed)
      when body.include?(":recycle:")
        remove_label(:Reviewed)
      end
    end

    private

      def body
        payload.comment.body
      end
  end
end
