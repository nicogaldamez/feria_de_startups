namespace :admin do
  
  desc "Seteo las categorias de los productos"
  task :set_products_categories => :environment do
    Product.find_each do |product|
      matching_categories = Category.search(product.description)
      product.categories.destroy_all
      product.categories << matching_categories
    end
  end

  
end
