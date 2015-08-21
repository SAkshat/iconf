class API::V1::ApplicationController < ActionController::Base

  private

    def load_user
      @user = User.find_by(id: params[:id])
      render json: { error: 'User not found', status: 404 } if !@user
    end

end

