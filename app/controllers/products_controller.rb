class ProductsController < ApplicationController
  def index
    @products = Product.all
    
    # Apply filters
    @products = @products.where("name ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    @products = @products.on_sale if params[:on_sale] == 'true'
    @products = @products.new_products if params[:is_new] == 'true'
    @products = @products.recently_updated if params[:recently_updated] == 'true'
    
    # Apply sorting
    case params[:sort]
    when 'price_asc'
      @products = @products.order(:price)
    when 'price_desc'
      @products = @products.order(price: :desc)
    when 'name_asc'
      @products = @products.order(:name)
    when 'newest'
      @products = @products.order(created_at: :desc)
    else
      @products = @products.order(created_at: :desc)
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    @products = Product.all
    
    if params[:q].present?
      @products = @products.where("name ILIKE ? OR descrption ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%")
    end
    
    render :index
  end
end
