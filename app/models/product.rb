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
  
  validates :name,  :presence => true
  validates :description,  :presence => true
  validates :url,  :presence => true
  validates :user_id,  :presence => true
  validates :name, uniqueness: {scope: :url, message: ' y la url ya existen'}
  
  belongs_to :user, :class_name => "User", :foreign_key => "user_id"
  has_many :votes, :class_name => "Vote", :foreign_key => "product_id", dependent: :destroy
  
  scope :today_products, -> { where('created_at::date > ?', Time.now - 24.hour) }
  
  include PgSearch
  pg_search_scope :search, against: [:name, :description],
                  :ignoring => :accents,
                  :using => { :tsearch => {:prefix => true} }
  
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
  
  def self.list (query)
    if query.present?
      result = search(query)
    else
      result = all
    end
    
    # Los productos se ordenan por VOTOS - DIAS_PUBLICADO + 1
    result = result.joins("LEFT JOIN votes ON votes.product_id = products.id")
    result = result.select("(count(votes) / (DATE_PART('day', current_date - products.created_at) + 1))
                            + 14400 - DATE_PART('day', current_date - products.created_at)
                            , 
                            (products.created_at > now() - interval '24 hour'),
                            products.id, products.name, products.created_at,
                            products.url, products.description, products.user_id")
    result = result.group('products.id')
    result = result.order('2 DESC, 1 DESC, products.created_at DESC')
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
end
