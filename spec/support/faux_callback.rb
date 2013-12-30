
class FauxCallback
  def invoke(*args)
    @invoked_args = args
  end

  def invoked(*args)
    @invoked_args
  end

  def configuration(&block)
    lambda do |on|
      on.success { |*args| invoke(:success, *args) }
      on.failure { |*args| invoke(:failure, *args) }
      block.call(on) if block_given?
    end
  end
end
