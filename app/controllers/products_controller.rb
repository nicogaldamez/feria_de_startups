class ProductsController < ApplicationController
  
  def index
    @products = Product.all.limit(50)
    @product = Product.new
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
      redirect_to root_url
    end
  end
  
  def destroy
    product = Product.find(params[:id])
    if product.is_owner?(current_user)
      product.destroy
    end
    redirect_to root_url
  end
  
  private

    def product_params
      params.require(:product).permit(:name, :url, :logo,
                                   :description, :video, :description)
    end  
end
