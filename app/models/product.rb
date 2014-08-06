# == Schema Information
#
# Table name: products
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  url         :string(255)
#  logo        :string(255)
#  video       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Product < ActiveRecord::Base
  
  validates :name,  :presence => true
  validates :description,  :presence => true
  validates :url,  :presence => true
  validates :user_id,  :presence => true
  
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :votes, :class_name => "Vote", :foreign_key => "product_id", dependent: :destroy
  
  default_scope { order('created_at desc') }
  
  def to_builder
    Jbuilder.new do |product|
      product.id id
      product.name name
      product.description description
      product.url url
      product.votes_count votes.count 
    end
  end
  
  def initial
    self.name[0,1]
  end
  
  def is_owner?(user)
    self.user == user
  end
end
