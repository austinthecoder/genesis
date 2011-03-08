class Admin::PagesController < AdminController

  before_filter :build_page, :only => %w(new create)

  def index
    @arranged_pages = pages_scope.arrange
  end

  def new
  end

  def create
    @page.save!
    redirect_to admin_pages_url, :notice => "Page was added."
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @page = pages_scope.find(params[:id])
  end

  private

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