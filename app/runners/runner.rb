
class Runner
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def run(*args, callbacks)
    @callbacks = callbacks
    do_run(*args)
  end

  def success(*args)
    callback(:success, *args)
  end

  def failure(*args)
    callback(:failure, *args)
  end

  def callback(name, *args)
    cb = @callbacks[name]
    if cb
      cb.(*args)
    else
      true
    end
  end
end
