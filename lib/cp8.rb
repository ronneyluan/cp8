require "payload"
require "events/event"
require "events/comment"
require "events/pull_request"
require "events/review"
require "label"

class Cp8
  class << self
    attr_accessor :github_client

    def github_client
      @github_client || octokit
    end

    private

      def octokit
        raise "OCTOKIT_ACCESS_TOKEN env variable not set" unless ENV["OCTOKIT_ACCESS_TOKEN"]
        Octokit::Client.new
      end
  end
end
