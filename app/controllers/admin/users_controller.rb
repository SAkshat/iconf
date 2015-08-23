class Admin::UsersController < Admin::AdminController

  before_action :load_user, only: [:enable, :disable]

  def index
    @users = User.order(:created_at)
  end

  def enable
    respond_to do |format|
      if @user.update(enabled: true)
        format.html { redirect_to :back, flash: { success: 'User successfully enabled' } }
        format.json { render json: { enabled: true, link: admin_user_disable_path(@user), type: :User, success_action: :enabled } }
      else
        format.html { redirect_to :back, flash: { error: 'User could not be enabled' } }
        format.json { render json: { invalid: true, type: :User, failure_action: :enabled } }
      end
    end
  end

  def disable
    respond_to do |format|
      if @user.update(enabled: false)
        format.html { redirect_to :back, flash: { success: 'User successfully disabled' } }
        format.json { render json: { enabled: false, link: admin_user_enable_path(@user), type: :User, success_action: :disabled } }
      else
        format.html { redirect_to :back, flash: { error: 'User could not be disabled' } }
        format.json { render json: { invalid: true, type: :User, failure_action: :enabled } }
      end
    end
  end

  private

    def load_user
      @user = User.find_by(id: params[:user_id])
      redirect_to :back, alert: "Couldn't find the required User" unless @user
    end

end
