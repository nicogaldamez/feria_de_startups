class AdminController < ApplicationController
  
  def send_daily
    @products = User.send_daily_email
  end
end
