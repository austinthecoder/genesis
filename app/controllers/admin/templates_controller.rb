class Admin::TemplatesController < AdminController

  before_filter :build_template, :only => %w(new create)

  def new
  end

  def create
    if @tpl.save
      flash.notice = "Wowza weeza! Template was created!"
      redirect_to admin_templates_url
    else
      flash.alert = "Houston, we have some problems."
      render :new
    end
  end

  private

  def build_template
    @tpl = current_user.templates.build(params[:template])
  end

end