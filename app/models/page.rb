class Page < ActiveRecord::Base
  belongs_to :wiki

  validates :name,
    presence: true,
    format: { with: /\A([A-Z][a-z0-9]+){2,}\Z/, message: "is not a wiki name" }

  def self.by_name(wiki_name, page_name)
    Page.
      includes(:wiki).
      joins(:wiki).
      where("wikis.name = ? and pages.name = ?", wiki_name, page_name).
      first
  end

  def html_content
    Kramdown::Document.new(referenced_content).to_html
  end

  def referenced_content
    content.gsub(/(([A-Z][a-z0-9]+){2,})/) { |page_name|
      "[#{page_name}](/#{wiki.name}/#{page_name})"
    }
  end
end
