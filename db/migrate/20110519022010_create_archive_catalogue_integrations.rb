class CreateArchiveCatalogueIntegrations < ActiveRecord::Migration
  def self.up
    create_table :archive_catalogue_integrations do |t|
      t.integer :archive_catalogue_id
      t.integer :archive_id
      t.string :url
      t.string :url_of_children
      t.integer :catalogue_position
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalogue_integrations
  end
end
