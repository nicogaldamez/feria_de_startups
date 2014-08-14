class AddReceiveNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :receive_notifications, :boolean, default: true
  end
end
