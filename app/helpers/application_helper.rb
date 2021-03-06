module ApplicationHelper
  include DdiHelper
  
  def archive_css(archive)
    archive.name == "ADA" ? 'default' : archive.slug.gsub("-", "_")
  end

  def subarchive_home_page?
    # If testing for non-ADA archive, use: @current_archive != Archive.ada
    @page.try(:title) == "Home"
  end

  # Returns the class (either "current" or "") for a menu item in the primary navigation
  def menu_item_class(menu_item_title)
    @current_archive == Archive.ada && menu_item_title == @title ? "current" : ""
  end

  def news_snippet(news)
    first_n_words(20, news.body)
  end

  def first_n_words(n, words)
    return if words.nil?
    words = words.gsub(/(<\/?[^>]*>|&[a-z]*;)/, " ").split(/\W/m).reject{|w| w.empty? }
    words = words.size > n ? words[0...n]+['...'] : words
    words * ' '
  end

  def archive_icon(archive)
    file_name = archive.slug.gsub("-", "")
    image_tag("structure/icon_#{file_name}.png", :title => archive.name, :align=> "top")
  end

  #outputs a deployment message for Product Owner to watch (so they know how fresh the code is)
  def deploy_log
    if File.exists?("tmp/deploy-log.txt")
      log = File.read("tmp/deploy-log.txt")
    end
  end

  #this checks to see if a human readable mapping (DdiMapping) exists for the DDI element
  def human_readable(ddi)
    mapping = ddi_mapping(ddi)
    mapping || ddi
  end
  
  def variable_anchor(variable)
    "#{variable.id}"
  end

  def google_analytics
    return if ["development", "devs", "test", "staging"].include? Rails.env
    %{<script type="text/javascript">var _gaq = _gaq || [];_gaq.push(['_setAccount', 'UA-25243708-1']);_gaq.push(['_setDomainName', '.ada.edu.au']);_gaq.push(['_trackPageview']);
 (function() {var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);})();
  </script>}.html_safe
  end
end
