class CreateArchiveCatalogs < ActiveRecord::Migration
  def self.up
    create_table :archive_catalogs do |t|
      t.string  :title, :null => false 
      t.string  :label, :null => false 
      t.integer :archive_id, :null => false
      t.integer :catalog_position
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.timestamps
    end
  end

  def self.down
    drop_table :archive_catalogs
  end
end
