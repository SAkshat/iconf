class Admin::UsersController < ApplicationController

  before_action :set_user, only: [:enable, :disable]

  def index
    @users = User.all.order(:id)
  end

  def enable
    @user.enabled = true
    respond_to do |format|
     if @user.save
        format.html {
          flash[:success] = 'User successfully enabled'
          redirect_to admin_users_path
        }
      else
        format.html {
          flash.now[:error] = 'User could not be enabled'
          redirect_to admin_users_path
        }
      end
    end
  end

  def disable
    @user.enabled = false
    respond_to do |format|
      if @user.save
        format.html {
          flash[:success] = 'User successfully disabled'
          redirect_to admin_users_path
        }
      else
        format.html {
          flash.now[:error] = 'User could not be disabled'
          redirect_to admin_users_path
        }
      end
    end
  end

  private

    def set_user
      @user = User.find_by(id: params[:user_id])
      redirect_to admin_users_path, alert: 'Couldn\'t find the required User' unless @user
    end

end
