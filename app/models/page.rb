class Page < ActiveRecord::Base
  include Biz::Mimic

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
end
