class AddCommentsCountToProducts < ActiveRecord::Migration

  def self.up

    add_column :products, :comments_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :products, :comments_count

  end

end
