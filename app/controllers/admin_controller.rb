class AdminController < ApplicationController

  before_action :authenticate_admin

  private

    def authenticate_admin
      if !current_user.admin?
        redirect_to :root, flash: { error: 'Access Denied' }
      end
    end

end
