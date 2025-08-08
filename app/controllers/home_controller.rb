class HomeController < ApplicationController
  def index
    @products = Product.limit(6)
    
    # Apply keyword search if present
    if params[:q].present?
      search_term = params[:q].downcase
      @products = @products.where(
        "LOWER(name) LIKE ? OR LOWER(descrption) LIKE ? OR LOWER(name) LIKE ? OR LOWER(descrption) LIKE ?", 
        "%#{search_term}%", "%#{search_term}%",
        "%#{categorize_search_term(search_term)}%", "%#{categorize_search_term(search_term)}%"
      )
    end
    
    # Apply filter if present
    @products = @products.recently_updated if params[:recently_updated] == 'true'
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
