module UsersHelper

  def user_enabled? (user)
    user.enabled
  end

  def get_user_name(user)
    if user.nickname?
      user.nickname
    else
      user.email
    end
  end

end
