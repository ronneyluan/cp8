class Issue < Hashie::Mash
  def wip?
    title_tags.include?("WIP")
  end

  def closed?
    state == "closed"
  end

  def card_ids
    delivers_meta_info.scan(/(?:#(\w+))/).flatten
  end

  private

    def title_tags
      title.scan(/\[(\w+)\]/).flatten
    end

    def delivers_meta_info
      title[/\[Delivers.+\]/] || ""
    end
end
