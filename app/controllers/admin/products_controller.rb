class Admin::ProductsController < Admin::BaseController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.all.order(created_at: :desc)
  end

  def show
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    
    if @product.save
      flash[:notice] = "Product created successfully."
      redirect_to admin_product_path(@product)
    else
      flash.now[:alert] = "Error creating product."
      render :new
    end
  end

  def edit
  end

  def update
    if @product.update(product_params)
      flash[:notice] = "Product updated successfully."
      redirect_to admin_product_path(@product)
    else
      flash.now[:alert] = "Error updating product."
      render :edit
    end
  end

  def destroy
    @product.destroy
    flash[:notice] = "Product deleted successfully."
    redirect_to admin_products_path
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :descrption, :price, :stock_quantity, :active, :image)
  end
end
