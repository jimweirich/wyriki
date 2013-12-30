require 'rspec/given'

unless defined?(require_dependency)
  def require_dependency(*files)
    require *files
  end
end
