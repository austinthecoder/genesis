class Admin::FieldsController < AdminController

  before_filter :find_field, :only => %w(edit update destroy)
  before_filter :find_template, :only => %w(index create edit update destroy)
  before_filter :build_field, :only => %w(index)
  before_filter :assign_fields, :only => %w(index create)

  ##################################################

  def index
  end

  def create
    @tpl.fields.add!(params[:field])
    redirect_to admin_template_fields_url(@tpl), :notice => "Kablam! Added!"
  rescue ActiveRecord::RecordInvalid => e
    @field = e.record
    flash.alert = "Dag nabbit. There were some problems."
    render :index
  end

  def edit
  end

  def update
    @field.update_attributes!(params[:field])
    redirect_to admin_template_fields_url(@tpl), :notice => "Field was saved."
  rescue ActiveRecord::RecordInvalid
    flash.alert = "Houston, we have some problems."
    render :edit
  end

  def destroy
    @field.destroy
    undo_link = view_context.button_to("Undo", revert_admin_version_path(@field.versions.scoped.last))
    redirect_to admin_template_fields_url(@field.template),
      :notice => "Field was removed. #{undo_link}"
  end

  ##################################################
  private

  def find_field
    @field = current_user.fields.find(params[:id], :readonly => false)
  end

  def find_template
    @tpl = @field.try(:template) || current_user.templates.find(params[:template_id])
  end

  def assign_fields
    @fields = @tpl.fields.order("created_at ASC")
  end

  def build_field
    @field = @tpl.fields.build(params[:field])
  end

end