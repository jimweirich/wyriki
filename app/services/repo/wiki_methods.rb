module Repo
  module WikiMethods
    include PageMethods

    def active_wikis
      Biz::Wiki.wraps(Wiki.active_wikis)
    end

    def new_wiki(attrs={})
      Biz::Wiki.wrap(Wiki.new(attrs))
    end

    def find_wiki(wiki_id)
      Biz::Wiki.wrap(Wiki.find(wiki_id))
    end

    def find_named_wiki(wiki_name)
      Biz::Wiki.wrap(Wiki.find_by_name(wiki_name))
    end

    def save_wiki(wiki)
      wiki.data.save
    end

    def update_wiki(wiki, attrs)
      wiki.data.update_attributes(attrs)
    end

    def destroy_wiki(wiki_id)
      Wiki.destroy(wiki_id)
    end
  end
end
