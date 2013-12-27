require 'spec_helper'

describe Page do
  Given(:content) { "CONTENT" }
  Given(:valid_attrs) { { name: "SomePage", content: content } }
  Given(:attrs) { valid_attrs }
  Given(:wiki) { Wiki.new(name: "Sample", home_page: "HomePage") }
  Given(:page) { wiki.pages.new(attrs) }

  describe "validations" do
    context "with valid attributes" do
      Then { must_be_valid(page) }
    end

    context "with missing name" do
      Given(:attrs) { valid_attrs.merge(name: nil) }
      Then { must_be_invalid(page, :name, /blank/) }
    end

    context "with invalid name" do
      Given(:attrs) { valid_attrs.merge(name: "page") }
      Then { must_be_invalid(page, :name, /not a wiki name/) }
    end
  end

  describe ".by_name" do
    Given!(:wiki) { Wiki.create!(Attrs.wiki) }
    Given!(:page) { wiki.pages.create!(Attrs.page) }

    Given!(:wiki2) { Wiki.create!(Attrs.wiki(name: "Other")) }
    Given!(:page2) { wiki2.pages.create!(Attrs.page) }

    When(:result) { Page.by_name(wiki.name, page.name) }
    Then { result == page }
  end

  describe "#html_content" do
    Given(:writer) { true }
    Given(:user) { double(:can_write? => writer) }
    Given(:context) {
      double(new_named_page_path: "MISSING", named_page_path: "EXISTING", current_user: user)
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
