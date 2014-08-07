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
    logger.debug("QUERY: #{query}")
    if query.present?
      result = search(query)
    else
      result = all
    end
    
    # Los productos se ordenan por VOTOS - DIAS_PUBLICADO + 1
    result = result.joins("LEFT JOIN votes ON votes.product_id = products.id")
    result = result.select("count(votes) / DATE_PART('day', current_date - products.created_at) + 1, 
                            products.id, products.name, products.created_at,
                            products.url, products.description, products.user_id")
    result = result.group('products.id')
    result = result.order('1 DESC, products.created_at DESC')
  end
end
