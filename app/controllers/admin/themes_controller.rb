class Admin::ThemesController < AdminController

  def show
    @tpls = current_user.templates
  end

end