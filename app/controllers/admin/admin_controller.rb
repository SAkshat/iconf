class Admin::AdminController < ApplicationController

  before_action :check_user_access

  private

    # [DONE TODO - S] Methos name incorrect.
    # [DONE TODO - S] This class should be inside admin directory and namespace.
    def check_user_access
      if !current_user.admin?
        redirect_to :root, flash: { error: 'Access Denied' }
      end
    end

end
