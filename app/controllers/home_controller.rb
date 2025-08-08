class HomeController < ApplicationController
  def index
    @products = Product.limit(6)
    
    # Apply filter if present
    @products = @products.recently_updated if params[:recently_updated] == 'true'
  end
end
