require "bundler"
require "json"

Bundler.require :default, ENV["RACK_ENV"].to_sym

require "sinatra/reloader" if development?

REVIEWED_LABEL = "Reviewed"

github = Octokit::Client.new(access_token: "20aab592dacbe7dc6cc30635f9e0b39d56b1634c")

begin
  github.label(repo, REVIEWED_LABEL)
rescue Octokit::NotFound
  github.add_label(repo, REVIEWED_LABEL, "207de5")
end


post '/payload' do

  payload = Hashie::Mash.new JSON.parse(request.body.read)

  repo = payload.repository.full_name

  if payload.pull_request
    # Start reviewing
    # Add WIP label
  elsif payload.comment
    # return if issue title is WIP
    if payload.comment.body.include?(":+1:")
      github.add_labels_to_an_issue(repo, payload.issue.number, [REVIEWED_LABEL])
    elsif payload.comment.body.include?(":recycle:")
      github.remove_label(repo, payload.issue.number, REVIEWED_LABEL)
    end
  end
  # comments = github.pull_request_comments(repo, pull_request.number)
end
