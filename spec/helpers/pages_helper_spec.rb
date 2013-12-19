require 'spec_helper'

describe PagesHelper do

  describe "named_page_link" do
    Given(:wiki) { double(name: "Wiki") }
    Given(:page) { double(wiki: wiki, name: "HomePage") }

    Then { helper.named_page_link(page) == "/Wiki/HomePage" }
  end
end
