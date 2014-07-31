class AddIndexesToUser < ActiveRecord::Migration
  def change
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :twitter_id, unique: true
  end
end
