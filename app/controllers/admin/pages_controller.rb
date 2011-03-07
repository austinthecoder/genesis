class Admin::PagesController < AdminController

  before_filter :build_page, :only => %w(new create)

  def index
    @arranged_pages = current_user.pages.arrange
  end

  def new
  end

  def create
    @page.save!
    flash[:notice] = "Page was added."
    redirect_to admin_pages_url
  end

  def edit
    @page = current_user.pages.find(params[:id])
  end

  private

  def build_page
    @page = current_user.pages.new(params[:page])
    if params[:page_id]
      @parent_page = current_user.pages.find(params[:page_id])
      @page.parent = @parent_page
    end
  end

end