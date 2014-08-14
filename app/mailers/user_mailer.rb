class UserMailer < ActionMailer::Base
  default from: "Feria de Startups <reply@feriadestartups.com>"

  def daily(user, products)
    @user = user
    @products = products
    
    mail to: user.email, subject: 'Tus productos han recibido votos hoy'
  end
end
