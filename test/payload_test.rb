require "test_helper"

class PayloadTest < Minitest::Test
  def setup
    Cp8.github_client = github
  end

  def test_creating_labels_if_they_dont_existdoes_something_useful
    github.expects(:label).with("balvig/bornholm", "Reviewed").once.raises(Octokit::NotFound)
    github.expects(:add_label).with("balvig/bornholm", "Reviewed", "207de5")
    Payload.new_from_json(json(:comment_plus_one)).process
  end

  def test_adding_reviewed_label_if_given_plus_one
    github.expects(:add_labels_to_an_issue).with("balvig/bornholm", 1, ["Reviewed"]).once
    Payload.new_from_json(json(:comment_plus_one)).process
  end

  def test_adding_reviewed_label_if_given_recyle
    github.expects(:remove_label).with("balvig/bornholm", 1, "Reviewed").once
    Payload.new_from_json(json(:comment_recycle)).process
  end

  private

    def json(file)
      @json ||= File.read File.expand_path("../fixtures/#{file}.json", __FILE__)
    end

    def github
      @github ||= stub(label: true, add_label: true, add_labels_to_an_issue: true)
    end
end
