module Events
  class IssueUpdate < Event
    private

      def issue
        payload.issue
      end
  end
end
