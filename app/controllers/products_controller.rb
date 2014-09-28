class ProductsController < ApplicationController
  before_filter :get_products, :only => [:index, :view]
  
  # --------------------------------------------
  def index
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  # --------------------------------------------
  def new
    @product = Product.new
    
    respond_to do |format|
      format.html { render partial: 'form' }
    end
  end
  
  # --------------------------------------------
  def create
    # Si es administrador puede subir como fake
    if !params[:product][:fake_user].nil? && params[:product][:fake_user] == '1' && current_user.admin
      user = User.fake_users.sample
    else
      user = current_user
    end
    
    @product = user.products.build(product_params)
    
    if @product.save
      render 'products/_product', locals: { product: @product }, 
          layout: false, status: :created
    else
      raise(RequestExceptions::BadRequestError.new(@product.errors.full_messages))
    end
  end
  
  # --------------------------------------------
  def edit
    @product = Product.find(params[:id])
    
    respond_to do |format|
      format.html { render partial: 'form' }
    end
  end
  
  # --------------------------------------------
  def update
    @product = Product.find(params[:id])
    
    respond_to do |format|
      if @product.update(product_params)
        format.js 
      else
        raise(RequestExceptions::BadRequestError.new(@product.errors.full_messages))  
      end
      
    end
  end
  
  # --------------------------------------------
  def view
    @product = Product.find(params[:id])
    render :index
  end
  
  # --------------------------------------------
  def show
    @product = Product.find(params[:id])
    render 'show', layout: nil
  end
  
  # --------------------------------------------
  def destroy
    product = Product.find(params[:id])
    product.destroy
    
    redirect_to :back
  end
  
  private
    # --------------------------------------------
    def product_params
      if current_user.is_admin?
        params.require(:product).permit(:name, :url, :description, :published, :mentions)
      else
        params.require(:product).permit(:name, :url, :description)
      end
    end  
    
    # --------------------------------------------
    def current_resource
      @product = @current_resource ||= Product.find(params[:id]) if params[:id]
    end
    
    # --------------------------------------------
    def get_products
      # @products = Product.list(params[:query], Product.per_page)
      @products = Product.list(params[:query])
      @products = @products.paginate(page: params[:page], per_page: Const::PRODUCTS_PER_PAGE)
    end
end
