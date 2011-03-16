class Admin::PagesController < AdminController

  before_filter :build_page, :only => %w(new create)
  before_filter :find_page, :only => %w(edit update edit_template destroy)
  before_filter :assign_templates, :only => %w(new create edit update edit_template destroy)

  def index
    @arranged_pages = pages_scope.arrange
  end

  def new
  end

  def create
    @page.save!
    redirect_to edit_admin_page_url(@page), :notice => "Page was saved."
  rescue ActiveRecord::RecordInvalid
    flash.alert = "Houston, we have some problems."
    render :new
  end

  def edit
  end

  def update
    @page.update_attributes!(params[:page])
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

  private

  def find_page
    @page = pages_scope.find(params[:id])
  end

  def pages_scope
    current_user.pages
  end

  def build_page
    @page = pages_scope.new(params[:page])
    if params[:page_id]
      @parent_page = pages_scope.find(params[:page_id])
      @page.parent = @parent_page
    end
  end

end