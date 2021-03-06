require 'spec_helper'

describe MenuItem do

  describe "class methods for CRUD lifecycle are hooked on content callbacks" do
    context "for content (pages)" do
      it "will create an instance from the callback on the page" do 
        page = Page.make
        menu_item = page.menu_item
        menu_item.valid?.should be_true
        menu_item.content.should == page
        menu_item.title.should == page.title
        menu_item.link.should == page.path.slug    
        menu_item.state.should == page.state  
      end
      
      it "validates that a menu item exists for the parent of the page it's handed" do
        parent_page = Page.make
        page = Page.make(:parent => parent_page, :archive => parent_page.archive)
        page.parent.should == parent_page
        page.menu_item.valid?.should be_true
        parent_page.menu_item.destroy
        page.title = "test"
        begin
          page.save!
          fail("page save should fail")
        rescue
          page.menu_item.should_not be_valid
        end
      end
      
      it "updates when the content is updated" do
        page = Page.make
        menu_item = page.menu_item
        page.title = "testing 1 2 3"
        page.save!
        menu_item.reload
        menu_item.title.should == "testing 1 2 3"
        menu_item.link.should == page.urn
        menu_item.state.should == page.state  
      end
    end
  end
end