class Admin::FieldsController < AdminController

  with_options :only => %w(index create) do |c|
    c.before_filter :find_template
    c.before_filter :build_field
    c.before_filter :assign_fields
  end

  ##################################################

  def index
  end

  def create
    @field.save!
    redirect_to admin_template_fields_url(@tpl), :notice => "Kablam! Added!"
  rescue ActiveRecord::RecordInvalid
    flash.alert = "Dag nabbit. There were some problems."
    render :index
  end

  def destroy
    field = current_user.fields.find(params[:id])
    field.destroy
    undo_link = view_context.button_to("Undo", revert_admin_version_path(field.versions.scoped.last))
    redirect_to admin_template_fields_url(field.template),
      :notice => "Field was removed. #{undo_link}"
  end

  ##################################################
  private

  def find_template
    @tpl = current_user.templates.find(params[:template_id])
  end

  def assign_fields
    @fields = fields_scope.order("created_at ASC")
  end

  def build_field
    @field = fields_scope.build(params[:field])
  end

  def fields_scope
    @tpl.fields
  end

end