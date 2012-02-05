module ArchiveStudiesHelper
  
  def study_field_table_row(key, study, fields)
    if fields.has_key?(key) and not fields[key].blank?
      row = "<tr class='#{cycle('standard', 'alt')}'>\n".html_safe
      row << "<td valign='top'>".html_safe
      row << (human_readable(key) || key)
      row << "</td><td valign='top'>".html_safe
      row << fields[key].to_s
      row << "</td>\n</tr>".html_safe
      
     fields.delete(key)
     row
   end
  end
  
  def variable_field(field)
    unless field[1].blank?
      key = (human_readable(field[0]) || field[0])
      "#{key}: #{field[1]}"
    end
  end

  def selected_tab_if(format_names, format = "study")
    css_class = nil
    css_class = "class='selected-tab'" if format_names.include?(format) or (format.nil? and format_names.include?("study")) 
    css_class
  end
    
  def conceal_unless(format_names, format = "title")
    #this if shouldn't be necessary, appears to be a bug in helpers using default values in method args
    if format.nil?
      format = "study"
    end
    
    "class = 'concealed'" unless format_names.include?(format)
  end  
  
  def variable_href(variable, archive_study)          
    "#{NESSTAR_SERVER}/webview/index.jsp?object=#{NESSTAR_SERVER}:80/obj/fVariable/#{variable.stdy_id}_#{variable.var_id}&cms_url=#{archive_study.urn}"
  end
  
  def up_arrow_anchor(position)
    "var-#{position - 1}"
  end
  
  def down_arrow_anchor(position)
    "var-#{position + 1}"
  end
  
  def related_material_url(related_material)
    if related_material.uri =~ /http/
      related_material.uri
    else
      uri = related_material.uri.gsub("..", "").sub(/^\//, '')
      if uri.start_with?('ADAData/')
        "#{root_url}/#{uri}"
      else
        "#{NESSTAR_SERVER}#{uri}"
      end
    end
  end
  
  def related_material_label_then_comment_then_file_name(related_material)
    link_text = ""

    if related_material.label
      link_text << "Label: #{related_material.label}"
    end
    if related_material.comment
      link_text += " " if not link_text.blank?
      link_text << "Comment: #{related_material.comment}"
    else
      related_material.uri.split(/\//).last
    end
  end

  def tick_class_for_study(archive_study)
    name = archive_study.archive.name
    standardised = name.gsub(/\s+/, '_').gsub('&', 'and')
    standardised.downcase + "_tick"
  end
end
