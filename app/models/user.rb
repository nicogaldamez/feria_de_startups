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
  before_save { self.email = email.downcase unless email.nil? }
  
  validates :name,  :presence => true, :uniqueness => true
  validates :username,  :presence => true, :uniqueness => true
  validates :email, :uniqueness => { case_sensitive: false }
  validates :uid,  :presence => true, :uniqueness => true
  
  has_many :products, :class_name => "Product", :foreign_key => "product_id", dependent: :destroy
  
  def self.from_omniauth(auth)
    where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
  end

  def self.create_from_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.username = auth["info"]["nickname"]
      user.name = auth["info"]["name"]
      user.avatar = auth['info']['image'].sub("_normal", "")
      user.description = auth['info']['description']
    end
  end
  
  def portrait(size)

      # Twitter
      # mini (24x24)                                                                  
      # normal (48x48)                                            
      # bigger (73x73)                                                
      # original (variable width x variable height)

      if self.avatar.include? "twimg"

          # determine filetype        
          case 
          when self.avatar.downcase.include?(".jpeg")
              filetype = ".jpeg"
          when self.avatar.downcase.include?(".jpg")
              filetype = ".jpg"
          when self.avatar.downcase.include?(".gif")
              filetype = ".gif"
          when self.avatar.downcase.include?(".png")
              filetype = ".png"
          else
              raise "Unable to read filetype of Twitter image for User ##{self.id}"
          end

          # return requested size
          if size == "original"
              return self.avatar
          else
              return self.avatar.gsub(filetype, "_#{size}#{filetype}")
          end

      end

  end
  
end
