class ChangeCategoriesColumnsType < ActiveRecord::Migration
  def change
    change_column :categories, :include_words, :text
    change_column :categories, :exclude_words, :text
  end
end