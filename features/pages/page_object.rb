class PageObject
  attr_reader :context, :app

  def initialize(app, context)
    @context = context
    @app = app
  end

  def make_current_page
    app.current_page = self
  end

  def method_missing(sym, *args, &block)
    context.send(sym, *args, &block)
  end
end
