class AddDailyToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_daily, :boolean, default: true
  end
end
