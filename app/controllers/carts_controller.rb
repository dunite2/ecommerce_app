class CartsController < ApplicationController
  def show
    @cart_items = current_cart.products_with_quantities
  end

  def add_item
    product = Product.find(params[:product_id])
    quantity = params[:quantity]&.to_i || 1
    
    current_cart.add_product(product.id, quantity)
    save_cart
    
    redirect_to request.referer || root_path, notice: "#{product.name} added to cart!"
  end

  def update_item
    current_cart.update_quantity(params[:product_id], params[:quantity])
    save_cart
    
    redirect_to cart_path, notice: "Cart updated!"
  end

  def remove_item
    product = Product.find(params[:product_id])
    current_cart.remove_product(product.id)
    save_cart
    
    redirect_to cart_path, notice: "#{product.name} removed from cart!"
  end

  def clear
    current_cart.clear
    save_cart
    
    redirect_to cart_path, notice: "Cart cleared!"
  end
end
