module SearchHelper 
  
  def highlight_excerpt(highlight)
    return if highlight.nil?
    highlights = highlight.format { |word|
      "<span class=\"highlight\">#{word}</span>".html_safe
    }
    highlights << "..."
    highlights.html_safe	
  end
    
  def selected_tab_if(format_names, format = "title")
    if format_names.include?(format || "title")
      "class='selected-tab'".html_safe
    end
  end
  
  def selected_menu_if(format_names, format = "title")
    if format_names.include?(format || "title")
      "class = 'selected-menu-item'".html_safe
    end
  end
  
  def conceal_unless(format_names, format = "title")
    unless format_names.include?(format || "title")
      "class = 'concealed'".html_safe
    end
  end
  
  def search_abbr(params, remove_filters = false)
    abbr = "#{params[:term]}"

    if params[:filters].any?
      abbr += ": "
      filter_list(abbr, params, remove_filters)
    end
  	
  	abbr.downcase
  end
  
  def filter_list(str, params, remove_filters = false)
    if params[:filters].any?
  		params[:filters].each do |facet|
  		  facet.each do |name, value|		    
    			str += "#{human_readable(name)} = #{value}" 

    			if remove_filters
  			    copy = Marshal.load(Marshal.dump(params)) #see http://www.michaelxavier.net/Deep-Copy-Params-Hash-When-working-with-Rack.html
    			  copy[:filters].first.delete(name)
    			  str += "(#{link_to '-', copy})"
  			  end
			  			  
    			unless name == params[:filters].first.keys.last 
    			  str += ", " 
    			end
  		  end 
  	  end 
	  end
	  str
  end
  
  def line_break_title(title, limit)
    return "" if title.nil? #bad data in some studies
    line_break = []
    bits = title.split(/\W/) 

    if bits.size > limit
      i = 0      
      for word in bits
        line_break << word
        i+= 1
        if i == limit + 1
          line_break << "<br/>"
          i = 0
        end
      end
    else
      return title
    end
    line_break.join " "
  end
  
  def multi_accordion_on_archive(div_id, current_archive_idx)
    if current_archive_idx 
      "$('##{div_id}').multiAccordion({active: [#{current_archive_idx}]});".html_safe
    else
      "$('##{div_id}').multiAccordion({active: false });".html_safe	
    end
  end

  def selected?(key, params)
    'selected =\'selected\'' if params[:order] == key
  end

  def path_without_order(params)
    copy = params.dup
    copy.delete(:order)
    transient_search_path(copy)
  end
end
