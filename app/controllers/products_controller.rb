class ProductsController < ApplicationController
  
  def index
    @products = Product.all
  end
  
  def new
    @product = Product.new
  end
  
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    if @product.save
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  private

    def product_params
      params.require(:product).permit(:name, :url, :logo,
                                   :description, :video, :description)
    end  
end
