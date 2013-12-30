
class FauxCallback
  def invoke(*args)
    @invoked_args = args
  end

  def invoked(*args)
    @invoked_args
  end

  def configure(*names)
    lambda do |on|
      configure_name(on, :success)
      configure_name(on, :failure)
      names.each do |name|
        configure_name(on, name)
      end
    end
  end

  private

  def configure_name(on, name)
    on.send(name) { |*args| invoke(name, *args) }
  end
end
