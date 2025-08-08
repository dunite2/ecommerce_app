class CartsController < ApplicationController
  def show
    @cart_items = current_cart.products_with_quantities
  end

  def add_item
    product = Product.find_by(id: params[:product_id])
    
    unless product
      flash[:alert] = "Product not found."
      redirect_to request.referer || root_path
      return
    end
    
    unless product.in_stock?
      flash[:alert] = "#{product.name} is currently out of stock."
      redirect_to request.referer || root_path
      return
    end
    
    quantity = params[:quantity]&.to_i || 1
    
    unless quantity > 0 && quantity <= 100
      flash[:alert] = "Invalid quantity. Please select between 1 and 100."
      redirect_to request.referer || root_path
      return
    end
    
    if current_cart.add_product(product.id, quantity)
      save_cart
      flash[:notice] = "#{product.name} added to cart!"
    else
      flash[:alert] = "Could not add #{product.name} to cart. Please check stock availability."
    end
    
    redirect_to request.referer || root_path
  end

  def update_item
    product = Product.find_by(id: params[:product_id])
    quantity = params[:quantity]&.to_i || 0
    
    unless product
      flash[:alert] = "Product not found."
      redirect_to cart_path
      return
    end
    
    unless quantity >= 0 && quantity <= 100
      flash[:alert] = "Invalid quantity. Please select between 0 and 100."
      redirect_to cart_path
      return
    end
    
    if current_cart.update_quantity(product.id, quantity)
      save_cart
      flash[:notice] = quantity > 0 ? "Cart updated!" : "#{product.name} removed from cart!"
    else
      flash[:alert] = "Could not update cart. Please check stock availability."
    end
    
    redirect_to cart_path
  end

  def remove_item
    product = Product.find_by(id: params[:product_id])
    
    unless product
      flash[:alert] = "Product not found."
      redirect_to cart_path
      return
    end
    
    if current_cart.remove_product(product.id)
      save_cart
      flash[:notice] = "#{product.name} removed from cart!"
    else
      flash[:alert] = "Could not remove #{product.name} from cart."
    end
    
    redirect_to cart_path
  end

  def clear
    current_cart.clear
    save_cart
    
    redirect_to cart_path, notice: "Cart cleared!"
  end
end
