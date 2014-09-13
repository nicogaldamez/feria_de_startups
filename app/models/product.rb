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
#  user_id     :integer
#

class Product < ActiveRecord::Base
  #--------------------------------------------- RELATION
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :votes, :class_name => "Vote", :foreign_key => "product_id", dependent: :destroy

  #--------------------------------------------- MISC  
  include PgSearch
  pg_search_scope :search, against: [:name, :description],
                  :ignoring => :accents,
                  :using => { :tsearch => {:prefix => true} }
                  
  #--------------------------------------------- VALIDATION
  validates :name,  :presence => true
  validates :description,  :presence => true
  validates :url,  :presence => true
  validates :user_id,  :presence => true
  validates :name, uniqueness: {scope: :url, message: ' y la url ya existen'}

  #--------------------------------------------- CALLBACK
  before_create :mark_trending
  before_save :mark_trending

  #--------------------------------------------- SCOPES
  scope :today_products, -> { where('created_at::date > ?', Time.now - 24.hour) }
  scope :recents, -> { includes(:user).order(created_at: :desc) }
  
  #--------------------------------------------- METHODS
  
    
  def to_builder
    Jbuilder.new do |product|
      product.(self, :id, :name, :description, :url, :votes_count)
    end
  end
  
  def initial
    self.name[0,1]
  end
  
  def is_owner?(user)
    self.user == user
  end
  
  def self.list (query)
    result = (query.present?) ? search(query) : all
    result = result.includes(:user)
    result = result.where(published: true)
    result = result.order(trending_until: :desc)
  end
  
  # Retorna los productos del usuario y cantidad de votos 
  # que recibieron votos en una fecha
  def self.voted(user='all', date)
    result = Product.all
    result = result.joins("INNER JOIN votes ON votes.product_id = products.id")
    result = result.joins("INNER JOIN users ON users.id = products.user_id")
    
    if user == 'all' # Todos los usuarios
      result = result.where('votes.created_at > ?', date)
    else
      result = result.where('products.user_id = ? and votes.created_at > ?', user.id, date)
    end
    
    result = result.select('count(votes.id) as votes_count, products.*, users.name as user_name')
    result = result.group('products.id, users.id')
    result = result.order('1 desc')
    result
  end
  
  
  private
  
  def mark_trending
    if published
      self.trending_until = 24.hours.from_now
    end    
  end
end
