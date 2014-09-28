class CommentsController < ApplicationController

  before_filter :get_product

  layout false

  # ---------------------------------------------
  def index
    @comments = @product.comments.includes(:user)
    @comment = @product.comments.build
  end

  # ---------------------------------------------
  def create
    @comment = @product.comments.build(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        @product.reload
        format.js { render partial: 'form_success'}
      else
        format.js { render partial: 'form_error'}
      end
    end
  end


  private
  # ---------------------------------------------
  def get_product
    @product = Product.find(params[:product_id])
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

end
