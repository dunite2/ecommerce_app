class Admin::DashboardController < Admin::BaseController
  def index
    @products_count = Product.count
    @users_count = User.count
    @orders_count = Order.count
    @pages_count = Page.count
    @recent_products = Product.order(created_at: :desc).limit(5)
    @recent_orders = Order.order(created_at: :desc).limit(5)
    @recent_pages = Page.order(created_at: :desc).limit(3)
  end
end
