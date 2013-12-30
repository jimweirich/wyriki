require_dependency './app/runners/named_callbacks'

class Runner
  attr_reader :context

  def initialize(context)
    @callbacks = NamedCallbacks.new
    @context = context
    yield(@callbacks) if block_given?
  end

  def repo
    context.repo
  end

  def success(*args)
    callback(:success, *args)
  end

  def failure(*args)
    callback(:failure, *args)
  end

  def callback(name, *args)
    @callbacks.call(name, *args)
    args
  end
end
