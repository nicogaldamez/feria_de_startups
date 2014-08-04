class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.text :description
      t.string :url
      t.string :logo
      t.string :video

      t.timestamps
    end
    
    add_index :products, :name
    add_index :products, :description
    add_index :products, :url, :unique => true
  end
end