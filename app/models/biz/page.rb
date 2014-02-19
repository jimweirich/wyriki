require 'kramdown'
require_dependency './app/models/biz/model'

module Biz
  class Page < Model
    def wiki
      Biz::Wiki.wrap(super)
    end

    def html_content(context)
      Kramdown::Document.new(referenced_content(context)).to_html
    end

    def referenced_content(context)
      content.gsub(/(([A-Z][a-z0-9]+){2,})/) { |page_name|
        if wiki.page?(context.repo, page_name)
          "[#{page_name}](#{context.named_page_path(wiki.name,page_name)})"
        elsif context.current_user.can_write?(wiki)
          "#{page_name}[?](#{context.new_named_page_path(wiki.name, page_name)})"
        else
          page_name
        end
      }
    end
  end
end
