require 'rspec/given'

require 'spec/support/faux_callback'
require 'spec/support/attrs'

unless defined?(require_dependency)
  def require_dependency(*files)
    require *files
  end
end
