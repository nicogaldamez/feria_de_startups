# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  twitter_id :string(255)
#  avatar     :string(255)
#  created_at :datetime
#  updated_at :datetime
#  username   :string(255)
#

class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  
  validates :name,  :presence => true, :uniqueness => true
  validates :username,  :presence => true, :uniqueness => true
  validates :email,  :presence => true, :uniqueness => { case_sensitive: false }
  validates :twitter_id,  :presence => true, :uniqueness => true
  
end
