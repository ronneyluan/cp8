class Event
  class Comment < Event
    REVIEWED_LABEL = "Reviewed"
    REVIEWED_COLOR = "207de5"

    def process
      init_labels
      if body.include?(":+1:")
        github.add_labels_to_an_issue(repo, number, [REVIEWED_LABEL])
      elsif body.include?(":recycle:")
        github.remove_label(repo, number, REVIEWED_LABEL)
      end
    end

    private

      def init_labels
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
