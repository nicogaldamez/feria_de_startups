# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  product_id :integer
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  #--------------------------------------------- RELATION
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  belongs_to :product, :class_name => "Product", :foreign_key => "product_id"
  
  #--------------------------------------------- MISC
  counter_culture :product
  
  #--------------------------------------------- VALIDATION
  validates :user_id, :presence => true
  validates :product_id, :presence => true
  
  #--------------------------------------------- CALLBACK

  #--------------------------------------------- SCOPES
  scope :recents, -> { order(created_at: :desc) }
  
  #--------------------------------------------- METHODS
  
end
