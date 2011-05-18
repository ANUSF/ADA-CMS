require 'spec_helper'
include Inkling::Util::Slugs

describe News do

  describe "validations" do
    context "news titles" do
      it "saves news with unique news title" do
        news = make_news
        news.errors.size.should == 0
      end

      it "is in an archive" do
        news = make_news(:archives => 1)
        news.archives.size.should == 1
      end

      it "rejects duplicate news titles" do
        news = make_news
        news.errors.any?.should == false

        news2 = News.new(:title => news.title, :user => news.user)
        news2.valid?.should == false
        news2.errors.any?.should == true
      end
    end
  end
end
