class Admin::PagesController < AdminController

  before_filter :only => %w(new create) do
    @parent_page = pages_scope.find(params[:page_id]) if params[:page_id]
  end
  before_filter :only => %w(edit update edit_template destroy) do
    @page = pages_scope.find(params[:id])
  end
  before_filter :assign_templates, :only => %w(new create edit update edit_template destroy)

##################################################

  def index
    @arranged_pages = pages_scope.arrange
  end

  def new
    @page = pages_scope.new(params[:page])
    @page.parent = @parent_page
  end

  def create
    page = pages_scope.add!(@parent_page, params[:page])
    redirect_to edit_admin_page_url(page), :notice => "Page was saved."
  rescue ActiveRecord::RecordInvalid => e
    @page = e.record
    flash.alert = "Houston, we have some problems."
    render :new
  end

##################################################

  def edit
  end

  def update
    pages_scope.update!(@page, params[:page])
    redirect_to edit_admin_page_url(@page), :notice => "Page was saved."
  rescue ActiveRecord::RecordInvalid
    flash.alert = "Houston, we have some problems."
    render :edit
  end

  def destroy
    @page.destroy
    undo_link = view_context.button_to("Undo", revert_admin_version_path(@page.versions.scoped.last))
    redirect_to admin_pages_url, :notice => "Page was removed. #{undo_link}"
  end

##################################################
  private

  def pages_scope
    current_user.pages
  end

end