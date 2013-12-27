class DefaultUser

  def can_read?(wiki)
    true
  end

  def can_write?(wiki)
    false
  end

  def can_administrate?(wiki)
    false
  end

  def logged_in?
    false
  end

  INSTANCE = new
end
