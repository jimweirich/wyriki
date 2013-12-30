
class NamedCallbacks
  def initialize
    @callbacks = {}
  end

  def method_missing(sym, *args, &block)
    @callbacks[sym] = block
  end

  def call(name, *args)
    name = name.to_sym
    cb = @callbacks[name]
    cb ? cb.call(*args) : true
  end
end
