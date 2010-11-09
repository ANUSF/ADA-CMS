class ContentController < Inkling::ContentController  
  before_filter :get_archives
  before_filter :get_ada_pages

  protected  
  def current_archive
    @current_archive = Archive.find(params[:archive_id]) if @current_archive.nil?
    @current_archive ||= ADAArchive.new #see lib/ada_archive.rb  
    @current_archive
  end
  
  def get_ada_pages
    @ada_parent_pages = Page.find_all_by_archive_id_and_parent_id(nil, nil)    
  end

  def get_archives
    @archives = Archive.all
  end
end
