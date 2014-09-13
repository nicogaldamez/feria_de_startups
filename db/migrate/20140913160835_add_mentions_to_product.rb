class AddMentionsToProduct < ActiveRecord::Migration
  def change
    add_column :products, :mentions, :string
  end
end
