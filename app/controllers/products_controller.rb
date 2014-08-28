class ProductsController < ApplicationController
  before_filter :fetch_product, :only => [:index, :view]
  def index
    
  end
  
  def new
    @product = Product.new
    render 'new', layout: nil
  end
  
  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    
    if @product.save
      render 'products/_product', locals: { product: @product }, layout: false, status: :created
    else
      raise(RequestExceptions::BadRequestError.new(@product.errors.full_messages))
    end
  end
  
  def view
    @product = Product.find(params[:id])
    render :index
  end
  
  def show
    @product = Product.find(params[:id])
    render 'show', layout: nil
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
    
    def current_resource
      @product = @current_resource ||= Product.find(params[:id]) if params[:id]
    end
    
    def fetch_product
      @products = Product.list(params[:query]).limit(50)
    end
end
