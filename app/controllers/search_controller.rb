class SearchController < ContentController
  
  respond_to :html
    
  def sphinx   
    @term = params[:term]
    @current_archive = Archive.find(params[:archive_id])
    # search_params = {:page => params[:page], :match_mode => :any}
    search_params = {:match_mode => :any}
    
    unless @current_archive == Archive.ada
      search_params[:archive_id] = @current_archive.id
    end
    
    @sphinx = ThinkingSphinx.search(@term, search_params)
    # @sphinx = ThinkingSphinx.search(@term)

    render :results
  end
end
