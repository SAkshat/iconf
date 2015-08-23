class Admin::AdminController < ApplicationController

  before_action :check_user_access

  private

    def check_user_access
      if !current_user.admin?
        redirect_to :root, flash: { error: 'Access Denied' }
      end
    end

end
