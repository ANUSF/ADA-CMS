# coding: utf-8

class Integrations::ArchiveCatalogs
  
  def self.create_or_update(statement, archive)
    
    if statement.objectType == "fCatalog"
      create_or_update_catalog(statement, archive)
    elsif statement.objectType == "fStudy"
      study, updated = create_or_update_study(statement, archive)   
      
      if updated or study.related_materials.count == 0
        Integrations::RelatedMaterials.create_or_update_by_study(study)     
      end

      if updated or study.variables.count == 0
        Integrations::Variables.create_or_update_by_study(study)        
      end
    end

    Nesstar::StatementEJB.find_all_by_subjectId(statement.objectId).each {|s| create_or_update(s, archive)}
  end
  
  
  def self.create_or_update_catalog(statement, archive)
    catalog_ejb = Nesstar::CatalogEJB.find_by_id(statement.objectId)
    data = statement.attributes

    if catalog_ejb.label.index("¤") 
      data[:label] = catalog_ejb.label.split("¤").last
    else
      data[:label] = catalog_ejb.label
    end
    
    parent_catalog = ArchiveCatalog.find_by_title(statement.subjectId)            
    archive_catalog = ArchiveCatalog.create_or_update_from_nesstar(data, archive, parent_catalog)
  end
  
  def self.create_or_update_study(statement, archive)
    studyejb = Nesstar::StudyEJB.find_by_stdyID(statement.objectId)
    study = Study.create_or_update_from_nesstar(studyejb.attributes)
    archive_study = ArchiveStudy.create_or_update_from_nesstar(study, archive)
    #plus, we create one for the ADA context, when searching
    archive_study = ArchiveStudy.create_or_update_from_nesstar(study, Archive.ada)
    parent_catalog = ArchiveCatalog.find_by_title(statement.subjectId)    
    ArchiveCatalogStudy.create_or_update_from_nesstar(archive_study, parent_catalog, statement.predicateIndex)
    study
  end
end
