class AdminController < ApplicationController
  
  def index
    @today_votes = Product.voted('all', Time.now - 24.hour)
    @today_products = Product.today_products
    @today_users = User.today_users
  end
  
  def send_daily
    @products = User.send_daily_email
    respond_to do |f|
      f.js { render js: "alert('Enviados');" }
    end
  end
end
