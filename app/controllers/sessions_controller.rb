class SessionsController < Devise::SessionsController

  def create
    auth = request.env['omniauth.auth']
    redirect_to root_path
  end

  protected

    def auth_hash
      request.env['omniauth.auth']
    end

end
