require "payload"
require "processor"
require "silent_chat_client"
require "trello"
require "slack-notifier"

class Cp8
  DEFAULT_CHAT_USER = "CP-8"

  class << self
    attr_writer :trello_client, :github_client, :chat_client

    def trello_client
      @trello_client || trello_flow_api
    end

    def github_client
      @github_client || octokit
    end

    def chat_client
      @chat_client || slack || silence
    end

    private

      def trello_flow_api
        raise "TRELLO_KEY and/or TRELLO_TOKEN not set" unless ENV["TRELLO_KEY"] && ENV["TRELLO_TOKEN"]
        @_trello_client ||= Trello.new(key: ENV["TRELLO_KEY"], token: ENV["TRELLO_TOKEN"])
      end

      def octokit
        raise "OCTOKIT_ACCESS_TOKEN not set" unless ENV["OCTOKIT_ACCESS_TOKEN"]
        @_octokit ||= Octokit::Client.new
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
