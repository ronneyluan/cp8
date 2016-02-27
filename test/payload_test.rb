require "test_helper"

class PayloadTest < Minitest::Test
  def setup
    Cp8.github_client = github
  end

  def test_it_does_something_useful
    github.expects(:label).with("balvig/bornholm", "Reviewed").once.raises(Octokit::NotFound)
    github.expects(:add_label).with("balvig/bornholm", "Reviewed", "207de5")
    github.expects(:add_labels_to_an_issue).with("balvig/bornholm", 1, ["Reviewed"]).once
    Payload.new_from_json(json).process
  end

  private

    def json
      @json ||= File.read File.expand_path("../fixtures/comment.json", __FILE__)
    end

    def github
      @github ||= mock
    end
end
