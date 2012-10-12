
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
    flag(Archive.indigenous)
    destroy_catalogs(Archive.indigenous)
    Rake::Task["integrate:indigenous"].execute
    unflag(Archive.indigenous)
  end

  task :social_science => :environment do
    flag(Archive.social_science)
    destroy_catalogs(Archive.social_science)
    Rake::Task["integrate:social_science"].execute
    unflag(Archive.social_science)
  end

  task :historical => :environment do
    flag(Archive.historical)
    destroy_catalogs(Archive.historical)
    Rake::Task["integrate:historical"].execute
    unflag(Archive.historical)
  end

  task :longitudinal => :environment do
    flag(Archive.longitudinal)
    destroy_catalogs(Archive.longitudinal)
    Rake::Task["integrate:longitudinal"].execute
    unflag(Archive.longitudinal)
  end
  
  task :qualitative => :environment do
    flag(Archive.qualitative)
    destroy_catalogs(Archive.qualitative)
    Rake::Task["integrate:qualitative"].execute
    unflag(Archive.qualitative)
  end
  
  task :international => :environment do
    flag(Archive.international)
    destroy_catalogs(Archive.international)
    Rake::Task["integrate:international"].execute
    unflag(Archive.international)
  end
  
  task :crime => :environment do
    flag(Archive.crime)
    destroy_catalogs(Archive.crime)
    Rake::Task["integrate:crime"].execute
    unflag(Archive.crime)
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
