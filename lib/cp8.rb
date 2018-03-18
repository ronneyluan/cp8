require "dotenv/load"
require "payload"
require "processor"
require "silent_chat_client"
require "slack-notifier"

class Cp8
  DEFAULT_CHAT_USER = "CP-8"

  class << self
    attr_writer :github_client, :chat_client

    def github_client
      @github_client || octokit
    end

    def chat_client
      @chat_client || slack || silence
    end

    private

      def octokit
        raise "OCTOKIT_ACCESS_TOKEN not set" unless ENV["OCTOKIT_ACCESS_TOKEN"]
        @_octokit ||= Octokit::Client.new(access_token: ENV["OCTOKIT_ACCESS_TOKEN"])
      end

      def slack
        return unless ENV["SLACK_WEBHOOK_URL"]
        @_slack ||= build_slack
      end

      def build_slack
        Slack::Notifier.new(
          ENV["SLACK_WEBHOOK_URL"],
          username: DEFAULT_CHAT_USER
        )
      end

      def silence
        @_silence ||= SilentChatClient.new
      end
  end
end
