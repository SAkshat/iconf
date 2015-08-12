class Admin::UsersController < Admin::AdminController

  before_action :load_user, only: [:enable, :disable]

  def index
    # [DONE TODO - S] Why order by id? Needed a field for default order.
    @users = User.order(:created_at)
  end

  def enable
    respond_to do |format|
      # [DONE TODO - S] Why update_column?
      if @user.update_attributes(enabled: true)
        format.html { redirect_to :back, flash: { success: 'User successfully enabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'User could not be enabled' } }
      end
    end
  end

  def disable
    respond_to do |format|
      # [DONE TODO - S] Why update_column? Should have a very strong reason to use it.
      if @user.update_attributes(enabled: false)
        format.html { redirect_to :back, flash: { success: 'User successfully disabled' } }
      else
        format.html { redirect_to :back, flash: { error: 'User could not be disabled' } }
      end
    end
  end

  private

    def load_user
      @user = User.find_by(id: params[:user_id])
      redirect_to :back, alert: "Couldn't find the required User" unless @user
    end

end
