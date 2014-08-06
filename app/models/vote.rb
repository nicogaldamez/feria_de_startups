class Vote < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :product_id, :presence => true
  
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :product, :class_name => "Product", :foreign_key => "product_id"
end
