class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :include_words
      t.string :exclude_words
      
      t.timestamps
    end
    
    create_table :categories_products, :force => true do |t|
      t.references :product
      t.references :category
      
      t.timestamps
    end
  end
end