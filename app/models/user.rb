# == Schema Information
#
# Table name: users
#
#  id                    :integer          not null, primary key
#  name                  :string(255)
#  email                 :string(255)
#  uid                   :string(255)
#  avatar                :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  username              :string(255)
#  provider              :string(255)
#  description           :text
#  receive_notifications :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  #--------------------------------------------- RELATION
  has_many :products, :class_name => "Product", :foreign_key => "user_id", dependent: :destroy
  has_many :votes, :class_name => "Vote", :foreign_key => "user_id", dependent: :destroy
  
  #--------------------------------------------- MISC  
  
  #--------------------------------------------- VALIDATION  
  validates :name,  :presence => true, :uniqueness => true
  validates :username,  :presence => true, :uniqueness => true
  validates :uid,  :presence => true, :uniqueness => true
  
  #--------------------------------------------- CALLBACK
  before_save { self.email = email.downcase unless email.nil? }

  #--------------------------------------------- SCOPES  
  scope :want_to_receive_votes, -> { where('receive_notifications and email is not null') }
  scope :want_to_receive_daily, -> { where('receive_daily and email is not null') }
  scope :today_users, -> { where('created_at::date > ?', Time.now - 24.hour) }
  scope :recents, -> { order(created_at: :desc) }
  scope :fake_users, -> { where(fake: true) }
  scope :except, ->(users) { where('id not in (:users)', users: users) }
  
  #--------------------------------------------- METHODS
  
  def self.from_omniauth(auth)
    user = where(auth.slice("provider", "uid")).first 
    if user.nil?
      user = create_update_from_omniauth(auth)
    else
      user = create_update_from_omniauth(auth, user)
    end
    
    user
  end

  def self.create_update_from_omniauth(auth, user=nil)
    if user.nil?
      user = new
    end
    
    user.provider = auth["provider"]
    user.uid = auth["uid"]
    user.username = auth["info"]["nickname"]
    user.name = auth["info"]["name"]
    user.avatar = auth['info']['image'].sub("_normal", "")
    user.description = auth['info']['description']
    
    user.save!
    user
  end
  
  def is_admin?
    self.admin
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
  
  def voted_for?(product)
    vote = self.votes.where(product_id: product.id)
    
    !vote.empty?
  end
  
  def voted_products
    Product.voted_by_user(self)
    
  end
  
  def self.send_voted_products
    users = User.want_to_receive_votes
    users.each do |user|
      products = Product.voted(user, Time.now - 24.hour)
      UserMailer.voted_products(user, products).deliver unless products.empty? or user.email.nil?
    end
  end
  
  def self.send_daily
    users = User.want_to_receive_daily
    users.each do |user|
      products = Product.list(nil).limit(10)
      UserMailer.daily(user, products).deliver unless products.empty? or user.email.nil?
    end
  end

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def add_reputation (value)
    self.reputation = reputation + value
    save
  end

  private

    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
    end
  
end
