class Event
  attr_reader :payload

  LABELS = {
    Reviewed: "207de5",
    WIP: "5319e7"
  }

  def initialize(payload)
    @payload = payload
  end

  def process
    raise "Implement this"
  end

  private

    def add_label(label)
      setup_label(label)
      github.add_labels_to_an_issue(repo, number, [label])
    end

    def remove_label(label)
      github.remove_label(repo, number, label)
    end

    def setup_label(label)
      github.label(repo, label)
    rescue Octokit::NotFound
      github.add_label(repo, label, LABELS[label])
    end

    def repo
      payload.repository.full_name
    end

    def github
      Cp8.github_client
    end
end
