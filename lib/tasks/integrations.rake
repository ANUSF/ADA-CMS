
namespace :integrate do
  task :indigenous => :environment do
    Integrations::Workflow.integrate("indigenous", Archive.indigenous)
  end

  task :social_science => :environment do
    Integrations::Workflow.integrate("social-science", Archive.social_science)
  end

  task :historical => :environment do
    Integrations::Workflow.integrate("historical", Archive.historical)
  end

  task :longitudinal => :environment do
    Integrations::Workflow.integrate("longitudinal", Archive.longitudinal)
  end
  
  task :qualitative => :environment do
    Integrations::Workflow.integrate("qualitative", Archive.qualitative)
  end
  
  task :international => :environment do
    Integrations::Workflow.integrate("international", Archive.international)
  end
  
  task :crime => :environment do
    Integrations::Workflow.integrate("crime-and-justice", Archive.crime)
  end
end

namespace :reset do
  task :indigenous => :environment do
    do_reset("indigenous", Archive.indigenous)
  end

  task :social_science => :environment do
    do_reset("social-science", Archive.social_science)
  end

  task :historical => :environment do
    do_reset("historical", Archive.historical)
  end

  task :longitudinal => :environment do
    do_reset("longitudinal", Archive.longitudinal)
  end
  
  task :qualitative => :environment do
    do_reset("qualitative", Archive.qualitative)
  end
  
  task :international => :environment do
    do_reset("international", Archive.international)
  end
  
  task :crime => :environment do
    do_reset("crime-and-justice", Archive.crime)
  end

  def do_reset(catalog_name, archive)
    flag(archive)
    Archive.transaction do
      destroy_catalogs(archive)
      Integrations::Workflow.integrate(catalog_name, archive)
    end
    unflag(archive)
  end

  def destroy_catalogs(archive)
    archive.archive_catalogs.each do |c| 
      c.archive_catalog_studies.each do |s|
        s.destroy
      end
      # c.reload if Rails.env == "development"
      c.path.delete
      c.delete #delete statement needed - nested set keeps sibling relations
    end
  end

  def flag(archive)
    system("touch tmp/#{archive.slug}-synching")
  end

  def unflag(archive)
    system("rm tmp/#{archive.slug}-synching")
  end
end
