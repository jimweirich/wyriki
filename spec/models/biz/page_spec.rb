require 'fast_helper'
require 'app/models/biz/page'

describe Biz::Page do

  Given(:content) { "CONTENT" }
  Given(:attrs) { Attrs.page }
  Given(:wiki) { double(Attrs.wiki) }
  Given(:page_data) { double(Attrs.page(wiki: wiki, content: content)) }
  Given(:page) { Biz::Page.wrap(page_data) }

  describe "#html_content" do
    Given(:found_page) { "PAGE" }
    Given(:writer) { true }
    Given(:user) { double(:can_write? => writer) }
    Given(:repo) { double(:find_named_page => found_page) }
    Given(:context) {
      double(
        new_named_page_path: "MISSING",
        named_page_path: "EXISTING",
        current_user: user,
        repo: repo)
    }

    describe "basic styling" do
      Given(:content) { "Hello, World\n" }
      Then { page.html_content(context) == "<p>Hello, World</p>\n" }
    end

    describe "page linking to existing page" do
      Given { wiki.stub(:page? => true) }
      Given { page.stub(:wiki => wiki) }
      Given(:content) { "This is a HomePage." }
      Then { page.html_content(context) =~ /<a[^>]+>HomePage<\/a>/ }
      Then { page.html_content(context) =~ /href="EXISTING"/ }
    end

    describe "page linking to missing page" do
      Given { wiki.stub(:page? => false) }
      Given { page.stub(:wiki => wiki) }
      Given(:content) { "This is a HomePage." }

      context "with writer" do
        Given(:writer) { true }
        Then { page.html_content(context) =~ /<a[^>]+>\?<\/a>/ }
        Then { page.html_content(context) =~ /href="MISSING"/ }
      end

      context "with reader" do
        Given(:writer) { false }
        Then { page.html_content(context) !~ /<a[^>]+>\?<\/a>/ }
      end
    end
  end

end
