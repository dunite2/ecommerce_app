class ProductsController < ApplicationController
  def index
    @products = Product.all
    @products = @products.where("name ILIKE ?", "%#{params[:q]}%") if params[:q].present?
  end

  def show
    @product = Product.find(params[:id])
  end

  def search
    @products = Product.all
    @products = @products.where("name ILIKE ? OR description ILIKE ?", "%#{params[:q]}%", "%#{params[:q]}%") if params[:q].present?
    render :index
  end
end
