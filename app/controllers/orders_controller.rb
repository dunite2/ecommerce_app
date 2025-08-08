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
    
    @order = current_user.orders.build(order_params)
    @order.total = current_cart.total_price
    @order.status = 'pending'

    if @order.save
      # Create order items from cart
      current_cart.items_hash.each do |product_id, quantity|
        product = Product.find(product_id)
        @order.order_items.create!(
          product: product,
          quality: quantity,
          price: product.price
        )
      end

      # Clear the cart after successful order
      session[:cart] = nil

      redirect_to @order, notice: 'Order was successfully created! Thank you for your purchase.'
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
