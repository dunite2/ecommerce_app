class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :initialize_cart

  private

  def initialize_cart
    @current_cart = SessionCart.new(session[:cart])
  end

  def current_cart
    @current_cart
  end

  def save_cart
    session[:cart] = @current_cart.to_hash
  end

  helper_method :current_cart
end
