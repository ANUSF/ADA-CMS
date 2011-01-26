class Archive < ActiveRecord::Base
  include Inkling::Slugs

  has_many :pages
  has_many :archive_to_study_blocks
  has_many :archive_studies
  has_many :archive_study_queries

  validates_presence_of :name
  validates_uniqueness_of :name
  
  validates_presence_of :slug
  before_validation :set_slug

  ADA  = "ADA"  
  SOCIAL_SCIENCE  = "Social Science"
  HISTORICAL      = "Historical" 
  INDIGENOUS      = "Indigenous"
  LONGITUDINAL    = "Longitudinal"
  QUALITATIVE     = "Qualitative"
  INTERNATIONAL   = "International"
  

  def self.ada
    self.find_by_name(ADA)
  end

  def self.social_science    
    self.find_by_name(SOCIAL_SCIENCE)
  end

  def self.historical
    self.find_by_name(HISTORICAL)
  end  

  def self.indigenous
    self.find_by_name(INDIGENOUS)
  end
  
  def self.longitudinal
    self.find_by_name(LONGITUDINAL)
  end
  
  def self.qualitative
    self.find_by_name(QUALITATIVE)
  end
  
  def self.international
    self.find_by_name(INTERNATIONAL)
  end
  
  def set_slug
    self.slug = sluggerize(name)
  end
  
  def to_s
    self.slug
  end
end