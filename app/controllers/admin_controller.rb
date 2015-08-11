class AdminController < ApplicationController

  before_action :authenticate_admin

  private

    # [TODO - S] Methos name incorrect.
    # [TODO - S] This class should be inside admin directory and namespace.
    def authenticate_admin
      if !current_user.admin?
        redirect_to :root, flash: { error: 'Access Denied' }
      end
    end

end
