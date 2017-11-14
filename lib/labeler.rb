require "label"

class Labeler
  def initialize(issue)
    @issue = issue
  end

  def run
    if wip?
      add_label(:WIP)
    else
      remove_label(:WIP)
    end
  end

  private

    attr_reader :issue

    def repo
      issue.repo
    end

    def wip?
      issue.wip?
    end

    def add_label(label)
      Label.new(repo, label).add_to(issue)
    end

    def remove_label(label)
      Label.new(repo, label).remove_from(issue)
    end
end
