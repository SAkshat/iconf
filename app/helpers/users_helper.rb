module UsersHelper

  def user_enabled? (user)
    user.enabled
  end

  def get_user_name(user)
    if user.nickname?
      return user.nickname
    else
      return user.title + ' ' + user.name
    end
  end

end
