#set_encoding: UTF-8
namespace :admin do
  
  desc "Seteo las categorias de los productos"
  task :set_products_categories => :environment do
    Product.find_each do |product|
      matching_categories = Category.search(product.description)
      product.categories.destroy_all
      product.categories << matching_categories
    end
  end
  
  desc "Fake user para los que sean admin"
  task :set_fake_users => :environment do
    puts 'Fake user para dueño de producto'
    products = Product.joins(:user).where('users.admin = true')
    products.find_each do |product|
      p = Product.find(product.id)
      p.user = User.fake_users.sample
      p.save
    end
    
    puts 'Fake user para voto de producto'
    votes = Vote.joins(:user).where('users.admin = true')
    votes.find_each do |vote|
      fake_users = User.except(vote.product.votes.select(:user_id)).fake_users
      if fake_users.size > 0
        v = Vote.find(vote.id)
        v.user = fake_users.sample
        v.save
      end
    end
  end
  
end
