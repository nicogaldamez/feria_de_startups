class AddPublishedToProduct < ActiveRecord::Migration
  def change
    add_column :products, :published, :bool, default: true
  end
end
