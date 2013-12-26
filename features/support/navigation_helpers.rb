module NavigationHelpers
  def path_to(name)
    case name
    when 'root'
      '/'
    else
      fail "Unknown page '#{name}' -- Add mapping to #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
