class ProductsController < ApplicationController
  def index
    @products = Product.all
    
    # Apply keyword search (enhanced to include category-like terms)
    if params[:q].present?
      search_term = params[:q].downcase
      @products = @products.where(
        "LOWER(name) LIKE ? OR LOWER(descrption) LIKE ? OR LOWER(name) LIKE ? OR LOWER(descrption) LIKE ?", 
        "%#{search_term}%", "%#{search_term}%",
        "%#{categorize_search_term(search_term)}%", "%#{categorize_search_term(search_term)}%"
      )
    end
    
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
      search_term = params[:q].downcase
      @products = @products.where(
        "LOWER(name) LIKE ? OR LOWER(descrption) LIKE ? OR LOWER(name) LIKE ? OR LOWER(descrption) LIKE ?", 
        "%#{search_term}%", "%#{search_term}%",
        "%#{categorize_search_term(search_term)}%", "%#{categorize_search_term(search_term)}%"
      )
    end
    
    render :index
  end

  private

  def categorize_search_term(term)
    # Map category-like search terms to product keywords
    category_mapping = {
      'powder' => 'matcha',
      'tea' => 'matcha',
      'ceremonial' => 'ceremonial grade',
      'premium' => 'ceremonial',
      'tools' => 'whisk bowl',
      'accessories' => 'whisk bowl chasen chawan',
      'traditional' => 'ceremonial grade',
      'japanese' => 'matcha',
      'organic' => 'matcha',
      'green' => 'matcha'
    }
    
    category_mapping[term] || term
  end
end
