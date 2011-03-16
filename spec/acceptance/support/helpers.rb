module HelperMethods
  def visit_archive(slug)
    archive = Archive.find_by_slug(slug)
    visit staff_archive_path(archive)
  end

  def visit_integrations(archive)
    visit_archive(archive.slug)
    visit staff_archive_integrations_path(archive)
    page.should have_content("Integrations")
  end
    

  def create_page(archive, page_title, page_body)
    visit_archive(archive.slug)

    within(:xpath, "//fieldset[@id='page-management']") do
      click_link("+")
    end

    fill_in("page_title", :with => page_title)
    fill_in("page_body_editor", :with => page_body)
    click_button("Create Page")
  end

  def create_news(archive, news_title, news_body)
    visit(new_staff_news_path)
    fill_in("news_title", :with => news_title)
    check(archive.name)
    fill_in("news_body_editor", :with => news_body)
    click_button("Create News")
    current_path.sub(%r{.*/},'').to_i
  end

  def upload_image(file_title, file_path)
    visit(new_staff_media_path)
    fill_in("media_title", :with => file_title)
    attach_file("media_asset", file_path)
    click_button("Create Media")
    current_path.sub(%r{.*/},'').to_i
  end

  def sign_in(user)
    visit '/login'
    fill_in('inkling_user_email', :with => user.email)
    fill_in('inkling_user_password', :with => 'test123')
    click_button('Sign in')
  end

  def sign_out
    visit logout_path
  end
end

RSpec.configuration.include HelperMethods, :type => :acceptance
