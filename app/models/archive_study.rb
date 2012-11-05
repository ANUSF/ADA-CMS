#The connection between an archive and a study.
#One study is kept in the system, it can be mapped to many archives with this class

class ArchiveStudy < ActiveRecord::Base
  include Inkling::Util::Slugs, ContentPathIncludesArchive

  acts_as_inkling 'ArchiveStudy'

  belongs_to :study
  has_many :archive_study_integrations
  belongs_to :archive
  has_many :archive_catalog_studies, :dependent => :destroy

  validates_presence_of :archive
  validates_presence_of :study
  validate :unique_archive_study_combination
  
  before_destroy { path.destroy }

  def self.create_or_update_from_nesstar(study, archive)
    archive_study = find_by_study_id_and_archive_id(study.id, archive.id)
    
    unless archive_study
      archive_study = ArchiveStudy.create!(:study => study, :archive => archive)
    end
    
    archive_study
  end
  
  #this method creates the slug to store on the Inkling::Path (see Inkling::Path) 
  def generate_path_slug
    slug = "/#{archive.slug}/"
    slug += sluggerize(study.ddi_id)
  end
  
  def unique_archive_study_combination
    if ArchiveStudy.find_all_by_study_id_and_archive_id(self.study.id, self.archive.id).size > 1
      errors.add(:study, "This study is already in #{archive.name}")
    end
  end
  
  def title
    study.title
  end

  # accessor methods expected by app/views/ckeditor/archive_study
  def url_content
    urn
  end

  def format_created_at
    self.created_at
  end
  
  def to_feedable
    {:title => study.title.html_safe, :url => "#{BASE_URL}#{urn}", :updated_at => created_at, :text => study.abstract_text.html_safe}
  end
end
