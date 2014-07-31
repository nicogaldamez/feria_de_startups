class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :twitter_id
      t.string :avatar

      t.timestamps
    end
  end
end
