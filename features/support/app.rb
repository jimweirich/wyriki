module AppContext
  def app
    @app ||= App.new(self)
  end

  class App
    attr_reader :context
    attr_accessor :current_page

    def initialize(context)
      @context = context
      @current_page = nil
    end

    def root_page
      RootPage.new(self, context)
    end

    def new_wiki_form
      NewWikiForm.new(self, context)
    end

    def login_page
      LoginPage.new(self, context)
    end

    def main_page(wiki_name)
      MainPage.new(self, context, wiki_name)
    end

    def content_page(wiki_name=nil, page_name=nil)
      ContentPage.new(self, context, wiki_name, page_name)
    end

    def new_page_form(wiki_name)
      NewPageForm.new(self, context, wiki_name)
    end
  end
end

World(AppContext)
