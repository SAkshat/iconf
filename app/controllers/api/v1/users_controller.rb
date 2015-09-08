class API::V1::UsersController < API::V1::ApplicationController

  before_action :load_user, only: [:discussions]

  def discussions
    render json: @user.discussions
  end

end
