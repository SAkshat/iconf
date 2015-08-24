class SessionsController < ApplicationController

  skip_before_action :authenticate_user!, only: [:create]
  before_action :check_if_user_logged_in, only: [:create]

  def create
    user = User.find_or_create_from_twitter_params(request.env['omniauth.auth'])
    sign_in_and_redirect user
  end

  protected

    def check_if_user_logged_in
      redirect_to :root, flash: { alert: 'You are already signed in' } if user_signed_in?
    end

end
