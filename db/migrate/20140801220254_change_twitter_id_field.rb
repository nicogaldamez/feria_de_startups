class ChangeTwitterIdField < ActiveRecord::Migration
  def change
    rename_column :users, :twitter_id, :uid
    add_column :users, :provider, :string
  end
end