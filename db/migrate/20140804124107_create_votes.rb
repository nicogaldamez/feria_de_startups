class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id
      t.integer :product_id

      t.timestamps
    end
    add_index :votes, :user_id
    add_index :votes, :product_id
  end
end