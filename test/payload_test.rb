require "test_helper"

class PayloadTest < Minitest::Test
  def setup
    ENV["TZ"] = "UTC"
    Time.stubs(:now).returns(Time.at(0))
    Cp8.github_client = github
    Cp8.trello_client = trello
  end

  def test_closing_stale_prs
    github.expects(:search_issues).with("repo:balvig/cp-8 is:open updated:<1969-12-04T00:00:00+00:00").once.returns(stub(items: [stub(number: 1)]))
    github.expects(:add_comment)
    create_payload(:pull_request_removed_wip).process
  end

  def test_creating_pr_with_wip_label
    github.expects(:label).with("balvig/cp-8", :WIP).once.raises(Octokit::NotFound)
    github.expects(:add_label).with("balvig/cp-8", :WIP, "5319e7").once
    github.expects(:add_labels_to_an_issue).with("balvig/cp-8", 1, [:WIP]).once
    create_payload(:pull_request_wip).process
  end

  def test_ignoring_label_if_already_added
    github.expects(:labels_for_issue).with("balvig/cp-8", 1).once.returns([stub(name: "WIP")])
    github.expects(:add_labels_to_an_issue).never
    create_payload(:pull_request_wip).process
  end

  def test_adding_wip_label
    github.expects(:label).with("balvig/cp-8", :WIP).once.raises(Octokit::NotFound)
    github.expects(:add_label).with("balvig/cp-8", :WIP, "5319e7").once
    github.expects(:add_labels_to_an_issue).with("balvig/cp-8", 1, [:WIP]).once
    create_payload(:pull_request_added_wip).process
  end

  def test_removing_wip_label
    github.stubs(:labels_for_issue).with("balvig/cp-8", 1).returns([stub(name: "WIP")])
    github.expects(:remove_label).with("balvig/cp-8", 1, :WIP).once
    create_payload(:pull_request_removed_wip).process
  end

  def test_not_adding_labels_to_plain_issues
    github.expects(:add_labels_to_an_issue).never
    create_payload(:issue_wip).process
  end

  def test_updating_trello_when_submitting_pr
    trello.expects(:update_card).with("1234", status: :finish).once
    trello.expects(:attach).with("1234", url: "https://github.com/balvig/cp-8/pull/3")
    create_payload(:pull_request_delivers).process
  end

  def test_updating_trello_when_closing_pr
    trello.expects(:update_card).with("1234", status: :accept).once
    create_payload(:pull_request_closed).process
  end

  def test_updating_multiple_card_when_closing_pr
    trello.expects(:update_card).with("1234", status: :accept).once
    trello.expects(:update_card).with("5678", status: :accept).once
    create_payload(:pull_request_closed_multiple).process
  end

  def test_keeping_cards_in_accepted_column_when_editing_closed_pr
    trello.expects(:update_card).with("1234", status: :finish).never
    trello.expects(:update_card).with("1234", status: :accept).once
    create_payload(:closed_pull_request_edited).process
  end

  private

    def create_payload(file)
      json = File.read File.expand_path("../fixtures/#{file}.json", __FILE__), encoding: "UTF-8"
      Payload.new_from_json(json)
    end

    def github
      @_github ||= stub(label: true, add_label: true, labels_for_issue: [], search_issues: stub(items: []))
    end

    def trello
      @_trello ||= stub
    end
end
