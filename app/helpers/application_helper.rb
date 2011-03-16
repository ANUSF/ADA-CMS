module ApplicationHelper
  def archive_css(archive)
    archive.name == "ADA" ? 'default' : archive.name.gsub(" ", "").underscore
  end
  
  def placeholder_icon
    icon = rand(3) + 1
    image_tag("placeholders/#{icon}.png", :size => "20x20", :class => "placeholder-icon")
  end
  
  #this should really be in another helper, but where - browsercms can use this helper
  def human_readable_check(ddi, dataset, current_user)
    mapping = DdiMapping.find_by_ddi(ddi)

    if mapping.nil?
      ddi
    else
     mapping.human_readable
    end
  end

  def nesstar_link(dataset)
    study_id = dataset.about.split(".").last
    return "http://assda-nesstar.anu.edu.au/webview/index.jsp?study=http%3A%2F%2Fassda-nesstar.anu.edu.au%3A80%2Fobj%2FfStudy%2Fau.edu.anu.assda.ddi.#{study_id}&amp;v=2&amp;mode=documentation&amp;submode=abstract&amp;top=yes"
  end
  
  def first_n_words(n, words)
    return if words.nil?
    words = words.gsub(/<\/?[^>]*>/, "").split(/\W/m).reject{|w| w.empty? }
    words = words.size > n ? words[0...n]+['...'] : words
    words * ' '
  end
  
  def archive_icon(archive)
    file_name = archive.slug.gsub("-", "")
    image_tag("structure/icon_#{file_name}.png")  
  end
  
  # def deploy_log
  #   log = File.read
  # end
end
