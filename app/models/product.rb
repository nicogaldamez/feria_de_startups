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
  has_and_belongs_to_many :categories
  has_many :votes, :class_name => "Vote", :foreign_key => "product_id", dependent: :destroy
  has_many :comments, dependent: :destroy

  #--------------------------------------------- MISC  
  include PgSearch
  pg_search_scope :search, against: [:name, :description],
                  associated_against: {categories: [:name]},
                  :ignoring => :accents,
                  :order_within_rank => "products.trending_until DESC",
                  :using => { 
                    :tsearch => {:prefix => true, :dictionary => "spanish"} 
                  }
                  
  #--------------------------------------------- VALIDATION
  validates :name,  :presence => true
  validates :description,  :presence => true
  validates :url,  :presence => true
  validates :user_id,  :presence => true
  validates :name, uniqueness: {scope: :url, message: ' y la url ya existen'}

  #--------------------------------------------- CALLBACK
  before_create :mark_trending
  before_create :set_categories

  #--------------------------------------------- SCOPES
  scope :today_products, -> { where('created_at::date > ?', Time.now - 24.hour) }
  scope :recents, -> { includes(:user).order(created_at: :desc) }
  scope :voted_by_user, ->(user) { joins(:votes).where('votes.user_id = :user', user: user).order(created_at: :desc) }
  scope :except, ->(users) { where('id not in (:users)', users: users) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }

  #--------------------------------------------- METHODS

  #---------------------------------------------
  def to_builder
    Jbuilder.new do |product|
      product.(self, :id, :name, :description, :url, :votes_count)
    end
  end

  #---------------------------------------------
  def initial
    self.name[0,1]
  end

  #---------------------------------------------
  def is_owner?(user)
    self.user == user
  end

  #---------------------------------------------
  def self.list (query)
    result = (query.present?) ? search(query) : all
    result = result.includes(:user)
    result = result.where(published: true)
    result = result.order(trending_until: :desc)
  end

  #---------------------------------------------
  def self.best_since (date)
    result = all
    result = result.includes(:user)
    result = result.where('published and trending_until > ?', date)
    result = result.order(votes_count: :desc)
  end

  #---------------------------------------------
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

  #---------------------------------------------
  def color
    if categories.count == 0
      colors = ["#f16565", "#6cc884", "#40d6d5","#6584ca"]
      colors[rand(colors.size)]
    else
      categories.first.color
    end
  end

  #---------------------------------------------
  def self.reset_categories
    Product.find_each do |product|
      matching_categories = Category.search(product.description)
      product.categories.destroy_all
      product.categories << matching_categories
    end
  end
  
  
  private
  #---------------------------------------------
  def mark_trending
    self.trending_until = 24.hours.from_now
  end

  #---------------------------------------------
  def set_categories
    matching_categories = Category.search(description)
    self.categories << matching_categories
  end
  
end
