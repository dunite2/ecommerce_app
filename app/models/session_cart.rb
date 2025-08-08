class SessionCart
  attr_reader :items

  def initialize(session_cart = {})
    @items = validate_and_clean_items(session_cart || {})
  end

  def add_product(product_id, quantity = 1)
    return false unless valid_product_id?(product_id) && valid_quantity?(quantity)
    
    product_id = product_id.to_s
    quantity = quantity.to_i
    
    # Check if product exists and is available
    product = Product.find_by(id: product_id)
    return false unless product&.in_stock?
    
    # Check stock limits
    current_quantity = @items[product_id] || 0
    new_quantity = current_quantity + quantity
    
    return false if new_quantity > product.stock_quantity || new_quantity > 100
    
    if @items[product_id]
      @items[product_id] = new_quantity
    else
      @items[product_id] = quantity
    end
    
    true
  end

  def remove_product(product_id)
    return false unless valid_product_id?(product_id)
    @items.delete(product_id.to_s)
    true
  end

  def update_quantity(product_id, quantity)
    return false unless valid_product_id?(product_id) && valid_quantity?(quantity, allow_zero: true)
    
    product_id = product_id.to_s
    quantity = quantity.to_i
    
    if quantity <= 0
      remove_product(product_id)
    else
      # Check stock limits
      product = Product.find_by(id: product_id)
      return false unless product && quantity <= product.stock_quantity && quantity <= 100
      
      @items[product_id] = quantity
    end
    
    true
  end

  def total_items
    @items.values.sum
  end

  def total_price
    @items.sum do |product_id, quantity|
      product = Product.find_by(id: product_id)
      product ? product.price * quantity : 0
    end
  end

  def products_with_quantities
    @items.map do |product_id, quantity|
      product = Product.find_by(id: product_id)
      next unless product
      
      {
        product: product,
        quantity: quantity,
        subtotal: product.price * quantity
      }
    end.compact
  end

  def items_hash
    @items
  end

  def empty?
    @items.empty?
  end

  def clear
    @items.clear
  end

  def to_hash
    @items
  end

  def valid?
    validate_cart_data
  end

  def errors
    @errors ||= []
  end

  private

  def valid_product_id?(product_id)
    return false if product_id.nil? || product_id.to_s.strip.empty?
    return false unless product_id.to_s.match?(/\A\d+\z/)
    true
  end

  def valid_quantity?(quantity, allow_zero: false)
    return false if quantity.nil?
    quantity = quantity.to_i
    return false if quantity < 0
    return false if !allow_zero && quantity == 0
    return false if quantity > 100
    true
  end

  def validate_and_clean_items(items_hash)
    return {} unless items_hash.is_a?(Hash)
    
    cleaned_items = {}
    items_hash.each do |product_id, quantity|
      next unless valid_product_id?(product_id) && valid_quantity?(quantity)
      
      # Verify product exists
      product = Product.find_by(id: product_id.to_s)
      next unless product
      
      # Ensure quantity doesn't exceed stock
      safe_quantity = [quantity.to_i, product.stock_quantity, 100].min
      cleaned_items[product_id.to_s] = safe_quantity if safe_quantity > 0
    end
    
    cleaned_items
  end

  def validate_cart_data
    @errors = []
    
    @items.each do |product_id, quantity|
      unless valid_product_id?(product_id)
        @errors << "Invalid product ID: #{product_id}"
        next
      end
      
      unless valid_quantity?(quantity)
        @errors << "Invalid quantity for product #{product_id}: #{quantity}"
        next
      end
      
      product = Product.find_by(id: product_id)
      unless product
        @errors << "Product not found: #{product_id}"
        next
      end
      
      unless product.in_stock?
        @errors << "Product out of stock: #{product.name}"
      end
      
      if quantity.to_i > product.stock_quantity
        @errors << "Quantity exceeds stock for #{product.name}"
      end
    end
    
    @errors.empty?
  end
end
