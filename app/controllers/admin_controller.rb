class AdminController < ApplicationController
  
  def index
    @today_votes = Product.voted('all', Time.now - 24.hour)
    @today_products = Product.today_products
    @users = User.order(created_at: :desc)
  end
  
  def send_voted_products
    @products = User.send_voted_products
    respond_to do |f|
      f.js { render js: "alert('Enviados');" }
    end
  end
  
  def send_daily
    @products = User.send_daily
    respond_to do |f|
      f.js { render js: "alert('Enviados');" }
    end
  end
end
