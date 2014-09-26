# set_encoding: UTF-8

class AdminController < ApplicationController
  layout = 'admin'
  
  # --------------------------------------------------------
  def index
    @products = Product.published.recents.limit(5)
    @products_count = Product.published.count
    @users = User.recents.limit(5)
    @users_count = User.count
    @votes = Vote.recents.limit(10).includes([:user,:product])
  end
  
  # --------------------------------------------------------
  def products
    @products = Product.recents.paginate(page: params[:page], per_page: 10)
    respond_to do |format|
      format.js 
      format.html      
    end
  end
  
  
  
  #----------------------------------------------
  def toggle_published
    @product = Product.find(params[:id])
    respond_to do |format|
      if @product.update(published: params[:product][:published], trending_until: Time.now + 24.hours)
        format.json { render json: @product.to_builder.target! }
      else
        raise(RequestExceptions::BadRequestError.new(@product.errors.full_messages))  
      end
      
    end
  end
  
  # --------------------------------------------------------
  def send_voted_products
    @products = User.send_voted_products
    respond_to do |f|
      f.js { render js: "alert('Enviados');" }
    end
  end
  
  # --------------------------------------------------------
  def send_daily
    @products = User.send_daily
    respond_to do |f|
      f.js { render js: "alert('Enviados');" }
    end
  end
end
