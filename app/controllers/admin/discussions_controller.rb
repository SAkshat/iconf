class Admin::UsersController < ApplicationController

  before_action :set_discussion, only: [:enable, :disable]

  def index
    @discussions = Discussion.all.order(:id)
  end

  def enable
    @discussion.enabled = true
    respond_to do |format|
     if @discussion.save
        format.html {
          flash[:success] = 'Discussion successfully enabled'
          redirect_to admin_discussions_path
        }
      else
        format.html {
          flash[:error] = 'Discussion could not be enabled'
          redirect_to admin_discussions_path
        }
      end
    end
  end

  def disable
    @discussion.enabled = false
    respond_to do |format|
      if @discussion.save
        format.html {
          flash[:success] = 'Discussion successfully disabled'
          redirect_to admin_discussions_path
        }
      else
        format.html {
          flash[:error] = 'Discussion could not be disabled'
          redirect_to admin_discussions_path
        }
      end
    end
  end

  private

    def set_discussion
      @discussion = Discussion.find_by(id: params[:discussion_id])
      redirect_to admin_discussions_path, alert: "Couldn't find the required Discussion" unless @discussion
    end

end
