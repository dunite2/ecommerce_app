class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!
  before_action :ensure_admin

  private

  def ensure_admin
    unless current_user&.admin?
      flash[:alert] = "Access denied. Admin privileges required."
      redirect_to root_path
    end
  end
end
