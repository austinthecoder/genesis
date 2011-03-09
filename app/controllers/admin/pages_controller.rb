class Admin::PagesController < AdminController

  before_filter :build_page, :only => %w(new create)
  before_filter :find_page, :only => %w(edit update)

  def index
    @arranged_pages = pages_scope.arrange
  end

  def new
  end

  def create
    @page.save!
    redirect_to edit_admin_page_url(@page), :notice => "Page was saved."
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
  end

  def update
    @page.update_attributes!(params[:page])
    redirect_to edit_admin_page_url(@page), :notice => "Page was saved."
  rescue ActiveRecord::RecordInvalid
    render :edit
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