class VotesController < ApplicationController
  
  before_filter :get_product
  
  def vote
    vote = Vote.find_by_user_id_and_product_id(current_user.id, params[:product_id])
    
    # Si no existe es que quiere borrar su voto
    if vote.nil?
      Vote.create(user_id: current_user.id, product_id: params[:product_id])
    else
      vote.destroy
    end
    
    respond_to do |format|
      format.json { render json: @product.to_builder.target! }
    end
  end
  
  private
    def get_product
      @product = Product.find(params[:product_id])
    end
    
    def up
      Vote.create(user_id: current_user.id, product_id: params[:product_id])
    
      respond_to do |format|
        format.json { render json: @product.to_builder.target! }
      end
    end

    def down
      Vote.find_by_user_id_and_product_id(current_user.id, params[:product_id]).destroy
    
      respond_to do |format|
        format.json { render json: @product.to_builder.target! }
      end
    end
end
