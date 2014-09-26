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
  after_save :mark_trending
  before_save :set_fake_user

  #--------------------------------------------- SCOPES
  scope :recents, -> { order(created_at: :desc) }
  
  #--------------------------------------------- METHODS
  
  
  private
  
  def mark_trending
    product.trending_until = 24.hours.from_now
    product.save
  end
  
  # Si es administrador asigno un fake user random
  def set_fake_user
    if user.admin
      fake_users = User.except(product.votes.select(:user_id)).fake_users
      # pry.binding
      return false if fake_users.size == 0
      self.user = fake_users.sample
    end
  end
  
end
