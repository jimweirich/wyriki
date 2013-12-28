require './features/pages/page_object'

class LoginPage < PageObject
  def visit
    context.visit("/session/new")
    make_current_page
  end

  def email=(value)
    fill_in("email", with: value)
  end

  def password=(value)
    fill_in("password", with: value)
  end

  def click_login
    click_button("Log in")
  end

  def login(email, password)
    visit
    self.email = email
    self.password = password
    click_login
  end
end
