require "user"

class Issue
  BOTS = %w(houndci-bot)

  attr_reader :number, :html_url, :repo

  def initialize(number:, repo:, title: nil, state: nil, html_url: nil, **other)
    @title = title
    @state = state
    @number = number
    @html_url = html_url
    @repo = repo
  end

  def wip?
    title_tags.include?("WIP")
  end

  def closed?
    state == "closed"
  end

  def card_ids
    delivers_meta_info.scan(/(?:#(\w+))/).flatten
  end

  def reviewers
    reviewer_logins.without(*BOTS).map do |login|
      User.new(login: login)
    end
  end

  private

    attr_reader :title, :state

    def reviewer_logins
      reviews.map(&:user).map(&:login).uniq
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

    def github
      Cp8.github_client
    end
end
