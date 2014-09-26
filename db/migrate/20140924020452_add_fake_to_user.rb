class AddFakeToUser < ActiveRecord::Migration
  def change
    add_column :users, :fake, :bool, default: false
  end
end
