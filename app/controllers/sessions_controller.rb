class SessionsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:create]

  def create
    auth = request.env['omniauth.auth']
    user = User.create_with(nickname: auth[:info][:nickname], image_path: auth[:info][:image], twitter_url: auth[:info][:urls][:Twitter]).find_or_create_by(uid: auth[:uid])
    user.save(validate: false)
    sign_in_and_redirect user
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

end
