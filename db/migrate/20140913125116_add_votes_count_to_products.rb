class AddVotesCountToProducts < ActiveRecord::Migration

  def self.up

    add_column :products, :votes_count, :integer, :null => false, :default => 0

  end

  def self.down

    remove_column :products, :votes_count

  end

end
