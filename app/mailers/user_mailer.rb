# encoding: UTF-8

class UserMailer < ActionMailer::Base
  default from: "Feria de Startups <reply@feriadestartups.com>"

  def voted_products(user, products)
    @user = user
    @products = products
    
    mail to: user.email, subject: 'Tus productos han recibido votos hoy'
  end
  
  def daily(user, products)
    @user = user
    @products = products
    
    mail to: user.email, subject: 'Lo destacado del momento'
  end
end
