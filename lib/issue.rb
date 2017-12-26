require "user"

class Issue
  BOTS = %w(houndci-bot)
  WIP_TAG = "WIP"

  attr_reader :number, :html_url, :repo, :title

  def initialize(number:, repo:, title: nil, state: nil, html_url: nil, user: nil, **other)
    @title = title
    @state = state
    @number = number
    @html_url = html_url
    @repo = repo
    @user_resource = user
  end

  def wip?
    title_tags.include?(WIP_TAG)
  end

  def closed?
    state == "closed"
  end

  def card_ids
    delivers_meta_info.scan(/(?:#(\w+))/).flatten
  end

  def reviewers
    reviewers_including_bots.reject do |user|
      user.login.in?(BOTS)
    end
  end

  def user
    return unless user_resource

    User.from_resource(user_resource)
  end

  def additions
    extended_pr_data[:additions]
  end

  def deletions
    extended_pr_data[:deletions]
  end

  private

    attr_reader :state, :user_resource

    def reviewers_including_bots
      reviews.map(&:user).map do |resource|
        User.from_resource(resource)
      end.uniq
    end

    def reviews
      github.pull_request_reviews(repo, number)
    rescue Octokit::NotFound
      []
    end

    def title_tags
      title.scan(/\[(\w+)\]/).flatten
    end

    def delivers_meta_info
      title[/\[Delivers.+\]/] || ""
    end

    def extended_pr_data
      @_extended_data ||= fetch_extended_pr_data
    end

    def fetch_extended_pr_data
      github.pull_request(repo, number)
    rescue Octokit::NotFound
      {}
    end

    def github
      Cp8.github_client
    end
end
