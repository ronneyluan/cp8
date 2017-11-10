module Events
  class Event
    attr_reader :payload

    def initialize(payload)
      @payload = payload
    end

    def process
      raise "Implement this"
    end

    private

      def add_label(label)
        Label.new(repo, label).add_to(issue)
      end

      def remove_label(label)
        Label.new(repo, label).remove_from(issue)
      end

      def repo
        payload.repo
      end
  end
end
