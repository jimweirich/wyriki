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
end
