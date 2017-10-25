module NavigationHelper
  def nav_active?(name)
    @nav == name
  end

  def nav_include?(name)
    @nav.include?(name)
  end

  # If check_include is passed, it check if the @nav has substring name else it should match
  def nav_class(name, check_include=false)
    if check_include
      nav_include?(name) ? "active" : ""
    else
      nav_active?(name) ? "active" : ""
    end
  end

  def set_nav(name)
    @nav = name
  end

  def current_nav
    @nav
  end
end
