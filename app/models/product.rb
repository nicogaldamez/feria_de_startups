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
  validates :url,  :presence => true, :uniqueness => true
  validates :user_id,  :presence => true
  
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :votes, :class_name => "Vote", :foreign_key => "user_id", dependent: :destroy
  
  def initial
    self.name[0,1]
  end
end
