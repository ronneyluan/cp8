module Events
  class Review < Event
    def process
      if state == "changes_requested"
        # Implement
      elsif state == "approved"
        add_label(:Reviewed)
      end
    end

    private

      def state
        payload.review.state
      end
  end
end
