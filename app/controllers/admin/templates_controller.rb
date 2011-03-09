class Admin::TemplatesController < AdminController

  before_filter :find_template, :only => %w(edit update)
  before_filter :assign_templates, :only => %w(new create edit update)
  before_filter :build_template, :only => %w(new create)

  def new
  end

  def create
    @tpl.save!
    redirect_to edit_admin_template_url(@tpl), :notice => "Wowza weeza! Template was created!"
  rescue ActiveRecord::RecordInvalid
    flash.alert = "Houston, we have some problems."
    render :new
  end

  def edit
  end

  def update
    @tpl.update_attributes!(params[:template])
    # TODO: set a notice
    redirect_to edit_admin_template_url(@tpl)
  rescue ActiveRecord::RecordInvalid
    flash.alert = "Houston, we have some problems."
    render :edit
  end

  private

  def find_template
    @tpl = Template.find(params[:id])
  end

  def build_template
    @tpl = templates_scope.build(params[:template])
  end

end