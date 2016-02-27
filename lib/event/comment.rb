class Event
  class Comment < Event
    REVIEWED_LABEL = "Reviewed"
    REVIEWED_COLOR = "207de5"

    def process
      case
      when body.include?(":+1:")      then add_reviewed_label
      when body.include?(":recycle:") then remove_reviewed_label
      end
    end

    private

      def add_reviewed_label
        setup_label
        github.add_labels_to_an_issue(repo, number, [REVIEWED_LABEL])
      end

      def remove_reviewed_label
        github.remove_label(repo, number, REVIEWED_LABEL)
      end

      def setup_label
        github.label(repo, REVIEWED_LABEL)
      rescue Octokit::NotFound
        github.add_label(repo, REVIEWED_LABEL, REVIEWED_COLOR)
      end

      def body
        @payload.comment.body
      end

      def number
        @payload.issue.number
      end
  end
end
