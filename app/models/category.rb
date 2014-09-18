class Category < ActiveRecord::Base
  #--------------------------------------------- RELATION
  has_and_belongs_to_many :products
  
  #--------------------------------------------- MISC  
  include PgSearch
  pg_search_scope :search, against: [:include_words],
                  :ignoring => :accents,
                  :using => { 
                    :tsearch => {:dictionary => "spanish", :any_word => true} }
                  
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
