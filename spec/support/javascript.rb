# def prepare_cms_data
#   
#   puts " ------------- setting up data <<<<<<<<<"
#   # DatabaseCleaner.start
#   ["administrator", "manager", "approver", "archivist", "member"].each do |role_name| 
#     Inkling::Role.create!(:name => role_name) if Inkling::Role.find_by_name(role_name).nil?
#   end    
# 
#   make_user(:administrator)
# 
#   ["ADA", "Social Science", "Historical", "Indigenous", "Longitudinal", "Qualitative", "International"].each do |archive_name|
#     if Archive.find_by_name(archive_name).nil?
#       archive = Archive.new(:name => archive_name)
#       archive.save!
# 
#       Page.create!(:archive_id => archive.id, :title => "Home", :body => "", :author =>  Inkling::Role.find_by_name("administrator").users.first, :partial => "/pages/home_page") unless Page.find_by_title_and_archive_id("Home", archive.id)
#     end
#   end  
# 
#   # #install the content theme, as we have to test front end presentation
#   theme = Inkling::Theme.install_from_dir("config/theme")
# end

RSpec.configure do |config|
  Sham.reset(:before_each) 

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    
    if example.metadata[:js]
      Capybara.current_driver = :selenium
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
    
    Capybara.reset_sessions! 
  end
  
  config.before(:each, :type => :acceptance) do
    #this is messy ... just hacking at getting specs working
    ["administrator", "manager", "approver", "archivist", "member"].each do |role_name| 
      Inkling::Role.create!(:name => role_name) if Inkling::Role.find_by_name(role_name).nil?
    end    
  
    make_user(:administrator)
  
    ["ADA", "Social Science", "Historical", "Indigenous", "Longitudinal", "Qualitative", "International"].each do |archive_name|
      if Archive.find_by_name(archive_name).nil?
        archive = Archive.new(:name => archive_name)
        archive.save!
  
        Page.create!(:archive_id => archive.id, :title => "Home", :body => "", :author =>  Inkling::Role.find_by_name("administrator").users.first, :partial => "/pages/home_page") unless Page.find_by_title_and_archive_id("Home", archive.id)
      end
    end  
  
    # #install the content theme, as we have to test front end presentation
    theme = Inkling::Theme.install_from_dir("config/theme")
  end

  config.after(:each) do
    Capybara.use_default_driver if example.metadata[:js]
    DatabaseCleaner.clean
  end
end