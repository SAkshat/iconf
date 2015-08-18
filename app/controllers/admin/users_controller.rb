class Admin::UsersController < Admin::AdminController

  before_action :load_user, only: [:enable, :disable]

  def index
    # [DONE TODO - S] Why order by id? Needed a field for default order.
    @users = User.order(:created_at)
  end

  def enable
    respond_to do |format|
      # [DONE TODO - S] Why update_column?
      if @user.update(enabled: true)
        format.html { redirect_to :back, flash: { success: 'User successfully enabled' } }
        format.json { render json: { enabled: true, url: admin_user_disable_path(@user)} }
      else
        format.html { redirect_to :back, flash: { error: 'User could not be enabled' } }
        format.json
      end
    end
  end

  def disable
    respond_to do |format|
      # [DONE TODO - S] Why update_column? Should have a very strong reason to use it.
      if @user.update(enabled: false)
        format.html { redirect_to :back, flash: { success: 'User successfully disabled' } }
        format.json { render json: { enabled: false, url: admin_user_enable_path(@user)} }
      else
        format.html { redirect_to :back, flash: { error: 'User could not be disabled' } }
        format.json
      end
    end
  end

  private

    def load_user
      @user = User.find_by(id: params[:user_id])
      redirect_to :back, alert: "Couldn't find the required User" unless @user
    end

end
