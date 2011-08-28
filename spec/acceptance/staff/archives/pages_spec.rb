require File.dirname(__FILE__) + '/../../acceptance_helper'

feature "Creating pages" do

  context "approver (administrator)" do  
    background do
      @admin = make_user(:administrator)
      sign_in(@admin)
    end
    
    after(:each) do
      sign_out
    end
    
    # scenario "I can access the archive page form"  do
    #   visit_archive("historical")
      
    #   within(:xpath, "//fieldset[@id='menu-management']") do
    #     click_link("new-page-link")
    #   end
      
    #   page.should have_content("New Page: Historical")  
    # end
    
    # scenario "I can create a page" do
    #   create_page(Archive.historical, "test page", "sample content")
    #   page.should have_content("Archives: Historical")
    #   page.should have_content("test page")
    # end
    
    # scenario "I can edit a page" do
    #   create_page(Archive.historical, "test page", "sample content")
    #   cms_page = Page.find_by_title("test page")
    #   visit edit_staff_archive_page_path(cms_page.archive, cms_page)
    #   page.should have_content("version #{cms_page.version}")
    #   fill_in("page_title", :with => "test page changed")
    #   click_button("Update Page")
    #   page.should have_content("test page changed")
    # end

    scenario "I can publish a page from draft mode (if I'm an approver)" do
      create_page(Archive.historical, "test page", "sample content")
      cms_page = Page.find_by_title("test page")
      visit edit_staff_archive_page_path(cms_page.archive, cms_page)
      draft_radio = page.find("input[@id='page_state_draft'][@checked]")
      draft_radio.should_not be_nil
      choose('page_state_publish')
      click_on('Update Page')
      publish_radio = page.find("input[@id='page_state_publish'][@checked]")
      publish_radio.should_not be_nil
    end

    # scenario "AJAX - the path displays after a title update of a page" do
    #   visit new_staff_archive_page_path(Archive.ada)
    #   fill_in("page_title", :with => "test 1 2 3")
    #  
    #   within(:xpath, "//input[@id='page_path']") do
    #     page.should have_content('test-1-2-3')
    #   end
    # end
    
    # scenario "I can preview a page before it is created in the db" do
    #   visit_archive("historical")
    #   click_link("Add a page")
    #   fill_in("page_title", :with => "testing 1 2 3")
    #   fill_in("page_body_editor", :with => "some text about stuff and stuff")
    #   click_link("Preview")
    #   
    #     within(:xpath, "//div[@id='preview']") do
    #       puts page.body
    #       page.should have_content('testing 1 2 3')
    #       page.should have_content('some text about stuff and stuff')
    #     end    
    # end
    
  end
end
