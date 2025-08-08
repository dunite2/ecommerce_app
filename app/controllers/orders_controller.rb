class OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_order, only: [:show]

  def index
    @orders = current_user.orders.recent.includes(:order_items, :products)
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def new
    redirect_to cart_path if current_cart.empty?
    @order = current_user.orders.build
    @cart_items = current_cart.products_with_quantities
    @total = current_cart.total_price
  end

  def create
    redirect_to cart_path if current_cart.empty?
    
    # Validate cart before creating order
    unless current_cart.valid?
      flash[:alert] = "Cart validation failed: #{current_cart.errors.join(', ')}"
      redirect_to cart_path
      return
    end
    
    @order = current_user.orders.build(order_params)
    @order.total = current_cart.total_price
    @order.status = 'pending'

    if @order.save
      # Create order items from cart with validation
      order_creation_successful = true
      error_messages = []
      
      current_cart.items_hash.each do |product_id, quantity|
        product = Product.find_by(id: product_id)
        
        unless product
          error_messages << "Product with ID #{product_id} not found"
          order_creation_successful = false
          next
        end
        
        order_item = @order.order_items.build(
          product: product,
          quality: quantity,
          price: product.price
        )
        
        unless order_item.save
          error_messages << "Failed to add #{product.name}: #{order_item.errors.full_messages.join(', ')}"
          order_creation_successful = false
        end
      end
      
      if order_creation_successful
        # Clear the cart after successful order
        session[:cart] = nil
        redirect_to @order, notice: 'Order was successfully created! Thank you for your purchase.'
      else
        # Rollback order if any items failed
        @order.destroy
        flash[:alert] = "Order creation failed: #{error_messages.join('; ')}"
        @cart_items = current_cart.products_with_quantities
        @total = current_cart.total_price
        render :new
      end
    else
      @cart_items = current_cart.products_with_quantities
      @total = current_cart.total_price
      render :new
    end
  end

  private

  def set_order
    @order = current_user.orders.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:shipping_address)
  end
end
