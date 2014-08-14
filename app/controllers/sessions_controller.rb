class SessionsController < ApplicationController
  
  def create
    redirect_to root_url unless params[:denied].nil?
    
    user = User.from_omniauth(env['omniauth.auth'])
    sign_in user
    redirect_to root_url
  end
  
  def destroy
    sign_out
    redirect_to root_url
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end
end
