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

  def html_content(context)
    Kramdown::Document.new(referenced_content(context)).to_html
  end

  def referenced_content(context)
    content.gsub(/(([A-Z][a-z0-9]+){2,})/) { |page_name|
      if wiki.page?(page_name)
        "[#{page_name}](#{context.named_page_path(wiki.name,page_name)})"
      elsif context.current_user.can_write?(wiki)
        "#{page_name}[?](#{context.new_named_page_path(wiki.name, page_name)})"
      else
        page_name
      end
    }
  end
end
