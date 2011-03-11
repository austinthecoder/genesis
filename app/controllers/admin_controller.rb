class AdminController < ApplicationController

  rescue_from ActiveRecord::RecordNotFound, :with => :render_not_found

  before_filter :authenticate_user!

  private

  def assign_templates
    @tpls = templates_scope.order("created_at DESC")
  end

  def templates_scope
    current_user.templates
  end

  def render_not_found
    render 'admin/shared/not_found', :status => 404
  end

end