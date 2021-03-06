class PagesController < ContentController
    
  respond_to :html
  
  def show
    @page = Page.find_by_id(params[:id])

    if @page.draft?
      return four_o_four
    end

    @current_archive = @page.archive
    @title = @page.title
    @archive_news = @current_archive.archive_news.find(:all, :order => "created_at DESC", :limit => 10)
    @archive_studies = @current_archive.archive_studies.find(:all, :order => "created_at DESC", :limit => 10) 
    respond_with(@page)
  end
  
  def show_by_slug
    path = Inkling::Path.find_by_slug(params[:slug])
    @page = path.content

    if @page.draft?
      return four_o_four
    end
    
    @current_archive = @page.archive
    @title = @page.title
    @archive_news = @current_archive.archive_news.find(:all, :order => "created_at DESC", :limit => 10)
    @archive_studies = @current_archive.archive_studies.find(:all, :order => "created_at DESC", :limit => 10) 

    render :action => :show
  end  
end
