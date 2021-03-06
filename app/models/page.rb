class Page < ActiveRecord::Base
  include Inkling::Util::Slugs, ContentPathIncludesArchive, Workflowable

  attr_protected :state #nice and simple protection until we get to Rails 3.1

  versioned
  
  acts_as_nested_set
  acts_as_inkling 'Page'
  
  after_create  :create_menu_item
  after_update  :update_menu_item, :if => "self.menu_item"

  belongs_to  :parent, :class_name => "Page"
  has_many    :children, :class_name => "Page", :foreign_key => "parent_id"
  belongs_to  :archive
  belongs_to  :author, :class_name => "User", :foreign_key => "author_id"
  has_one     :menu_item, :as => :content, :dependent => :destroy

  before_validation :link_title_defaults_to_title
  before_validation :default_partial, :if => "self.partial.nil?"

  validate :unique_archive_and_link_combination, :if => "self.archive"
  validate :same_archive_as_parent
  validates_presence_of :author
  validates_presence_of :archive
  validates_presence_of :link_title
  validates_presence_of :partial

  PARTIALS = {"Default" => "/pages/default_page",
   "Home" => "/pages/home_page",
   "Breakout Page" => "/pages/breakout_page",
   "News Page" => "/pages/news_page"}

  def self.archive_root_pages(archive, state = nil)
    roots = Page.roots
    archive_roots = []

    for page in roots
      if page.archive == archive
        case state
        when Workflowable::PUBLISH
          archive_roots << page if page.published?
        when Workflowable::DRAFT
          archive_roots << page if page.draft?
        else
          archive_roots << page 
        end
      end
    end
    archive_roots
  end

  def unique_archive_and_link_combination
    pre_existing = Page.find_all_by_archive_id_and_title(self.archive.id, self.title)

    return if pre_existing.size == 0
    return if pre_existing.size == 1 and pre_existing[0].id == self.id

    errors.add(:name, "There's a page already named #{self.title} in the #{self.archive.name} archive ...") if pre_existing and self.archive
  end

  def same_archive_as_parent
    if parent and parent.archive != self.archive
      errors.add(:archive, "Child page (#{self.title}) must be in the same archive (#{self.parent.archive.name}) as its parent (#{self.parent.title}).")
    end
  end

  def link_title_defaults_to_title
    if self.link_title.nil?
      self.link_title = title
    end
  end

  def default_partial
    self.partial = "/pages/default_page"
  end

  def create_menu_item
    MenuItem.create_from_page(self)
  end
  
  def update_menu_item
    MenuItem.update_from_page(self, self.menu_item)
  end

  # accessor methods expected by the ckeditor browse views (can refactor, we have our own copies)
  def url_content
    self.urn
  end

  def format_created_at
    self.created_at
  end
end
