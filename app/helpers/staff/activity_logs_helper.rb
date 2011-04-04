module Staff::ActivityLogsHelper
  
  def log_icon(category)
    case category
    when "integration"
      image_tag('icons/server.png')
    when "page"
      image_tag('icons/page.png')
    when "study"
      image_tag('icons/book_open.png')
    when "users"
      image_tag('icons/user.png')
    end
  end
  
end