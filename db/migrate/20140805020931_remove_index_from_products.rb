class RemoveIndexFromProducts < ActiveRecord::Migration
  def change
    remove_index :products, :url
  end
end