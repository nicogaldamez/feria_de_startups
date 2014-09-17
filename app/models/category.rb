class Category < ActiveRecord::Base
  #--------------------------------------------- RELATION
  has_and_belongs_to_many :product
  
  #--------------------------------------------- MISC  
  
  #--------------------------------------------- VALIDATION  
  validates :name,  :presence => true, :uniqueness => true
  validates :include_words,  :presence => true
  
  #--------------------------------------------- CALLBACK

  #--------------------------------------------- SCOPES  
  default_scope -> { order(:name) }
  #--------------------------------------------- METHODS
  
  def to_s
    name
  end
  
end
