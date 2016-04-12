require "test_helper"

class PayloadTest < Minitest::Test
  def setup
    Cp8.github_client = github
  end

  def test_creating_labels_if_they_dont_exist
    github.expects(:label).with("balvig/cp-8", :Reviewed).once.raises(Octokit::NotFound)
    github.expects(:add_label).with("balvig/cp-8", :Reviewed, "207de5").once
    github.expects(:add_labels_to_an_issue).once
    create_payload(:comment_plus_one).process
  end

  def test_adding_reviewed_label_if_given_plus_one
    github.expects(:add_labels_to_an_issue).with("balvig/cp-8", 1, [:Reviewed]).once
    create_payload(:comment_plus_one).process
  end

  def test_adding_reviewed_label_if_given_recyle
    github.expects(:labels_for_issue).with("balvig/cp-8", 1).once.returns([stub(name: "Reviewed")])
    github.expects(:remove_label).with("balvig/cp-8", 1, :Reviewed).once
    create_payload(:comment_recycle).process
  end

  def test_ignoring_comment_if_already_added
    github.expects(:labels_for_issue).with("balvig/cp-8", 1).once.returns([stub(name: "Reviewed")])
    github.expects(:add_labels_to_an_issue).never
    create_payload(:comment_plus_one).process
  end

  def test_not_adding_labels_to_plain_issues
    github.expects(:add_labels_to_an_issue).never
    create_payload(:issue_comment).process
  end

  def test_adding_wip_label
    github.expects(:label).with("balvig/cp-8", :WIP).once.raises(Octokit::NotFound)
    github.expects(:add_label).with("balvig/cp-8", :WIP, "5319e7").once
    github.expects(:add_labels_to_an_issue).with("balvig/cp-8", 3, [:WIP]).once
    create_payload(:pull_request_wip).process
  end

  private

    def create_payload(file)
      json = File.read File.expand_path("../fixtures/#{file}.json", __FILE__), encoding: "UTF-8"
      Payload.new_from_json(json)
    end

    def github
      @github ||= stub(label: true, add_label: true, labels_for_issue: [])
    end
end
