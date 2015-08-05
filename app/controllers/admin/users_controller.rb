class Admin::UsersController < AdminController

  before_action :load_user, only: [:enable, :disable]

  def index
    @users = User.all.order(:id)
  end

  def enable
    respond_to do |format|
     if @user.update_attribute(:enabled, true)
        format.html { redirect_to admin_users_path, success: 'User successfully enabled' }
      else
        format.html { redirect_to admin_users_path, flash: { error: 'User could not be enabled' } }
      end
    end
  end

  def disable
    respond_to do |format|
     if @user.update_attribute(:enabled, false)
        format.html { redirect_to admin_users_path, success: 'User successfully disabled' }
      else
        format.html { redirect_to admin_users_path, flash: { error: 'User could not be disabled' } }
      end
    end
  end

  private

    def load_user
      @user = User.find_by(id: params[:user_id])
      redirect_to admin_users_path, alert: "Couldn't find the required User" unless @user
    end

end
