module ArchiveStudiesHelper
  
  def study_field_table_row(key, fields)
    if fields.has_key?(key) and not fields[key].blank?
      row = "<tr class='#{cycle('standard', 'alt')}'>\n".html_safe
      row << "<td valign='top'>".html_safe
      row << (human_readable(key) || key)
      row << "</td><td valign='top'>".html_safe
      row << fields[key].to_s
      row << "</td>\n</tr>".html_safe
      
      row
   end
  end
  
  def keyword_rows(key, fields)
    entries = (fields[key].to_s || '').split(';').map(&:strip)

    if entries.size() > 0
      res = "".html_safe

      res << "<tr class='#{cycle('standard', 'alt')}'>\n".html_safe
      res << "<td valign='top'>".html_safe
      res << (human_readable(key) || key)
      res << "</td><td valign='top'>".html_safe
      res << entries.first
      res << "</td>\n</tr>".html_safe
      
      entries.drop(1).each do |s|
        res << "<tr class='#{cycle('standard', 'alt')}'>\n".html_safe
        res << "<td valign='top'>".html_safe
        res << "</td><td valign='top'>".html_safe
        res << s
        res << "</td>\n</tr>".html_safe
      end

      res
    end
  end

  def subtable(keys, fields)
    entries = keys.map { |key| (fields[key].to_s || '').split(';').map(&:strip) }
    n = entries.map(&:size).max

    if keys.size() <= 1
      keyword_rows(keys.first, field)
    elsif n > 0
      res = "".html_safe

      res << "<tr>\n".html_safe
      res << "<td valign='top'>".html_safe
      res << (human_readable(keys.first) || keys.first)
      res << "</td>".html_safe
      res << "<td valign='top' class='study-subtable-container'>".html_safe
      res << "<table class='study-subtable'>\n".html_safe

      res << "<thead>\n<tr>\n".html_safe
      res << "<th></th>\n".html_safe
      keys.drop(1).each do |key|
        res << "<th>".html_safe
        res << (human_readable(key) || key)
        res << "</th>\n".html_safe
      end
      res << "</tr>\n</thead>\n<tbody>\n".html_safe

      0.upto(n-1).each do |i|
        res << "<tr class='#{cycle('standard', 'alt')}'>\n".html_safe

        0.upto(keys.size()-1) do |j|
          res << "<td valign='top'>".html_safe
          res << entries[i][j] || ""
          res << "</td>\n".html_safe
        end

        res << "</tr>\n".html_safe
      end

      res << "</tbody>\n</table>\n".html_safe
      
      res
    end
  end
  
  def producer_string(fields)
    if fields['stdy_producer'].blank?
      fields['stdy_producer_abbr']
    elsif fields['stdy_producer_abbr'].blank?
      fields['stdy_producer']
    else
      "#{fields['stdy_producer']} [#{fields['stdy_producer_abbr']}]"
    end
  end

  def time_range_string(key_start, key_end, fields)
    if fields[key_end].blank?
      fields[key_start]
    elsif fields[key_start].blank?
      field[key_end]
    else
      "Start date: #{fields[key_start]}; End date: #{fields[key_end]}"
    end
  end

  def variable_field(field)
    unless field[1].blank?
      key = (human_readable(field[0]) || field[0])
      "#{key}: #{field[1]}"
    end
  end

  def selected_tab_if(format_names, format = "study")
    if format_names.include?(format || "study")
      "class='selected-tab'".html_safe
    end
  end
    
  def conceal_unless(format_names, format = "title")
    unless format_names.include?(format || "study")
      "class = 'concealed'".html_safe
    end
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
        "/#{uri}"
      else
        "#{NESSTAR_SERVER}/#{uri}"
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
