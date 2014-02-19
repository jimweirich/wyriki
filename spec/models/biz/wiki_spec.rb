require 'fast_helper'
require 'app/models/biz/wiki'

describe Biz::Wiki do

  Given(:wiki_data) { double(Attrs.wiki(:biz? => false)) }
  Given(:wiki) { Biz::Wiki.new(wiki_data) }

  describe "#page?" do
    context "with existing page" do
      Given(:repo) { double(:find_named_page => :page) }
      Then { wiki.page?(repo, "PageName") }
    end
    context "with non-existing page" do
      Given(:repo) { double(:find_named_page => nil) }
      Then { ! wiki.page?(repo, "PagName") }
    end
  end

end
