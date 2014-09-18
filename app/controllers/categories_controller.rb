# set_encoding: UTF-8
class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  
  layout 'admin'
  
  # GET /categories
  def index
    @categories = Category.all
  end

  # GET /categories/1
  def show
    @products = @category.products
  end

  # GET /categories/new
  def new
    @category = Category.new
    
    render partial: 'form'
  end

  # GET /categories/1/edit
  def edit
    render partial: 'form'
  end

  # POST /categories
  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path
    else
      redirect_to categories_path, error: 'Ocurrió un error al actualizar la categoría'
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      redirect_to categories_path
    else
      redirect_to categories_path, error: 'Ocurrió un error al actualizar la categoría'
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
    redirect_to categories_url, notice: 'Categoría eliminada.'
  end
  
  def reset_products_categories
    Product.reset_categories
    redirect_to categories_url, notice: 'Recalculo exitoso.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = Category.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def category_params
      params.require(:category).permit(:name, :include_words, :exclude_words, :color)
    end
end
