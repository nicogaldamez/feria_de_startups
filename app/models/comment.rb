class Comment < ActiveRecord::Base
  #--------------------------------------------- RELATION
  belongs_to :user
  belongs_to :product

  #--------------------------------------------- MISC
  counter_culture :product

  #--------------------------------------------- VALIDATION
  validates :body,  :presence => true
  validates :user,  :presence => true
  # validates :product,  :presence => true

  #--------------------------------------------- CALLBACK

  #--------------------------------------------- SCOPES
  default_scope -> { order(:created_at) }
  #--------------------------------------------- METHODS
end
