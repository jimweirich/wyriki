require 'spec_helper'

describe Page do
  Given(:valid_attrs) { { name: "SomePage", content: "CONTENT" } }
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
end
