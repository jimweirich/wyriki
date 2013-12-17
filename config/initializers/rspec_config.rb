
# Configure
Wyriki::Application.config.generators do |g|
  g.test_framework  :rspec, :fixture => false
  g.view_specs      false
  g.helper_specs    false
end
