class Admin::PagesController < Admin::BaseController
  before_action :set_page, only: [:show, :edit, :update, :destroy]

  def index
    @pages = Page.all.order(:title)
  end

  def show
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)
    
    if @page.save
      flash[:notice] = "Page created successfully."
      redirect_to admin_page_path(@page)
    else
      flash.now[:alert] = "Error creating page."
      render :new
    end
  end

  def edit
  end

  def update
    if @page.update(page_params)
      flash[:notice] = "Page updated successfully."
      redirect_to admin_page_path(@page)
    else
      flash.now[:alert] = "Error updating page."
      render :edit
    end
  end

  def destroy
    @page.destroy
    flash[:notice] = "Page deleted successfully."
    redirect_to admin_pages_path
  end

  private

  def set_page
    @page = Page.find(params[:id])
  end

  def page_params
    params.require(:page).permit(:title, :content, :slug)
  end
end
