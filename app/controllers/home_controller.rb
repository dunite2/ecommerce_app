class HomeController < ApplicationController
  def index
    @products = Product.limit(6)
    
    # Apply filters if present
    @products = @products.on_sale if params[:on_sale] == 'true'
    @products = @products.new_products if params[:is_new] == 'true'
    @products = @products.recently_updated if params[:recently_updated] == 'true'
  end
end
