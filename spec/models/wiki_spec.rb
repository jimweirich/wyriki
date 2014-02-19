require 'spec_helper'

describe Wiki do
  Given(:valid_attrs) { { name: "Name", home_page: "HomePage" } }
  Given(:attrs) { valid_attrs }
  Given(:wiki) { Wiki.new(attrs) }

  describe "validations" do
    context "with valid attributes" do
      Then { must_be_valid(wiki) }
    end

    context "with multiple words in home page" do
      Given(:attrs) { valid_attrs.merge(home_page: "ThisHasMultipleWords") }
      Then { must_be_valid(wiki) }
    end

    context "with missing name" do
      Given(:attrs) { valid_attrs.merge(name: nil) }
      Then { must_be_invalid(wiki, :name, /blank/) }
    end

    context "with duplicate name" do
      Given { Wiki.create!(valid_attrs) }
      Given(:attrs) { valid_attrs }
      Then { must_be_invalid(wiki, :name, /taken/) }
    end

    context "with missing home_page" do
      Given(:attrs) { valid_attrs.merge(home_page: nil) }
      Then { must_be_invalid(wiki, :home_page, /blank/) }
      Then { must_be_invalid(wiki, :home_page, /is not a wiki name/) }
    end

    context "with a home_page without an initial cap" do
      Given(:attrs) { valid_attrs.merge(home_page: 'homepage') }
      Then { must_be_invalid(wiki, :home_page, /is not a wiki name/) }
    end

    context "with a home_page without a second word" do
      Given(:attrs) { valid_attrs.merge(home_page: 'Homepage') }
      Then { must_be_invalid(wiki, :home_page, /is not a wiki name/) }
    end

    context "with a home_page with no lowercase" do
      Given(:attrs) { valid_attrs.merge(home_page: 'SOS') }
      Then { must_be_invalid(wiki, :home_page, /is not a wiki name/) }
    end

    context "with a home_page with doubled caps" do
      Given(:attrs) { valid_attrs.merge(home_page: 'DontUseDOS') }
      Then { must_be_invalid(wiki, :home_page, /is not a wiki name/) }
    end
  end

end
