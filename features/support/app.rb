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

    def new_wiki_page
      NewWikiPage.new(self, context)
    end

    def login_page
      LoginPage.new(self, context)
    end

    def content_page(wiki_name, page_name)
      ContentPage.new(self, context, wiki_name, page_name)
    end
  end
end

World(AppContext)
