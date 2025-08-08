class SessionCart
  attr_reader :items

  def initialize(session_cart = {})
    @items = session_cart || {}
  end

  def add_product(product_id, quantity = 1)
    product_id = product_id.to_s
    if @items[product_id]
      @items[product_id] += quantity.to_i
    else
      @items[product_id] = quantity.to_i
    end
  end

  def remove_product(product_id)
    @items.delete(product_id.to_s)
  end

  def update_quantity(product_id, quantity)
    product_id = product_id.to_s
    if quantity.to_i <= 0
      remove_product(product_id)
    else
      @items[product_id] = quantity.to_i
    end
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
end
