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

      def repo
        payload.repo
      end
  end
end
