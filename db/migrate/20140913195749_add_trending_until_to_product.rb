# set_encoding: UTF-8
class AddTrendingUntilToProduct < ActiveRecord::Migration
  def change
    add_column :products, :trending_until, :datetime
    
    # Cargo como trending_until la fecha del último voto + 24 hs
    Product.find_each do |product|
      if product.votes.size > 0
        product.trending_until = product.votes.last.created_at + 24.hours
        p "actualizo la fecha trending para #{product.name} según el último voto"
      else
        product.trending_until = product.created_at + 24.hours
        p "actualizo la fecha trending para #{product.name} según la fecha de creación"
      end 
      product.save     
    end
  end
end