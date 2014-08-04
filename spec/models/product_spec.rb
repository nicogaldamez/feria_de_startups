# encoding: UTF-8

require 'spec_helper'

describe Product do
  
  before { @product = Product.new(name: 'Nuevo producto', description: 'Una descripción del producto',
                                  url: 'http://producto.com', logo: 'http://producto.com/logo', 
                                  video: 'http://producto.com/video', user_id: 1)}
  
  subject { @product }
  
  it { should respond_to(:name) }                                
  it { should respond_to(:description) }                                
  it { should respond_to(:url) }                                
  it { should respond_to(:logo) }                                
  it { should respond_to(:video) }                                
  it { should respond_to(:user) }                                
  
  it { should be_valid }
  
  describe "con nombre vacio" do
    before { @product.name = " " }
    it { should_not be_valid}
  end
  
  describe "con descripción vacio" do
    before { @product.description = " " }
    it { should_not be_valid}
  end
  
  describe "con url vacio" do
    before { @product.url = " " }
    it { should_not be_valid}
  end
  
  describe "con usuario vacio" do
    before { @product.user_id = " " }
    it { should_not be_valid}
  end
  
  describe "con url repetida" do
    before do 
      product_with_same_url = @product.dup
      product_with_same_url.save
    end
    
    it { should_not be_valid }    
  end
  
end
