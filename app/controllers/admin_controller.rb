class AdminController < ApplicationController

  before_filter :authenticate_user!

  private

  def assign_templates
    @tpls = templates_scope.order("created_at DESC").all
  end

  def templates_scope
    current_user.templates
  end

end