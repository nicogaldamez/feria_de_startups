# encoding: UTF-8

class UsersController < ApplicationController
  
  # -------------------------------------------------
  def index
    @users = User.recents.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.js 
      format.html { render 'index', layout: 'admin'}      
    end
  end
  
  # -------------------------------------------------
  def edit
    @user = User.find(params[:id])
    render 'edit', layout: nil
  end
  
  # -------------------------------------------------
  def show
    @user = User.find(params[:id])
    @products = @user.products.published.order(created_at: :desc).limit(10)
    @votes = @user.voted_products.limit(10)
  end
  
  # -------------------------------------------------
  def update
    user = current_user
    if user.update_attributes(user_params)
      current_user = user
      redirect_to root_url, notice: 'Se actualizaron tus datos'
    else
      redirect_to root_url, error: 'Ocurrió un error al actualizar tus datos'
    end
  end
  
  private

    def user_params
      params.require(:user).permit(:email, :receive_notifications, :receive_daily)
    end  
    
    def current_resource
      @user = @current_resource ||= User.find(params[:id]) if params[:id]
    end

end
