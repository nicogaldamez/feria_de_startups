class Comment < ActiveRecord::Base
  #--------------------------------------------- RELATION
  belongs_to :user
  belongs_to :product

  #--------------------------------------------- MISC
  counter_culture :product

  #--------------------------------------------- VALIDATION
  validates :body,  :presence => true
  validates :user,  :presence => true

  #--------------------------------------------- CALLBACK
  after_save :mark_trending

  #--------------------------------------------- SCOPES
  default_scope -> { order(:created_at) }
  #--------------------------------------------- METHODS


  private

  def mark_trending
    product.trending_until = 24.hours.from_now
    product.save
  end

end
