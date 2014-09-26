# set_encoding: UTF-8
class VotesController < ApplicationController
  
  before_filter :get_product
  
  def vote(user=current_user)
    save_vote(user)
    respond_to do |format|
      format.json { render json: @product.to_builder.target! }
    end
  end
  
  # Voto con un fake user
  def fake_vote
    fake_users = User.except(@product.votes.select(:user_id)).fake_users
    if fake_users.size == 0
      @msg = 'No existen más usuarios fake para votar'
      @type = 'danger'
    else
      save_vote(fake_users.sample)
      @msg = 'Voto contabilizado'
      @type = 'success'
    end
    respond_to do |format|
      format.js { render 'fake_vote_result'}
    end
  end
  
  # Elimino un voto con un fake user
  def remove_fake_vote
    fake_users = User.where(id: @product.votes.select(:user_id)).fake_users
    if fake_users.size == 0
      @msg, @type = 'No existen votos fake', 'danger'
    else
      save_vote(fake_users.sample)
      @msg, @type = 'Voto eliminado', 'success'
    end
    respond_to do |format|
      format.js { render 'fake_vote_result'}
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
    
    def save_vote(user)
      vote = Vote.find_by_user_id_and_product_id(user.id, params[:product_id])
    
      # Si no existe es que quiere borrar su voto
      if vote.nil?
        Vote.create(user_id: user.id, product_id: params[:product_id])
      else
        vote.destroy
      end
      @product.reload
    end
end
