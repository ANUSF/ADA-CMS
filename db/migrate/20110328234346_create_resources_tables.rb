class CreateResourcesTables < ActiveRecord::Migration
  extend Inkling::Util::MigrationHelpers

  def self.up
    create_table 'documents' do |t|
      t.integer :user_id, :null => :false
      t.string :title, :null => false
      t.string :resource_file_name
      t.string :resource_content_type
      t.integer :resource_file_size
      t.integer :archive_id, :integer
      t.datetime :resource_updated_at
      t.timestamps
    end

    add_foreign_key(:documents, :user_id, :users)
    add_foreign_key :documents, :archive_id, :archives
    add_index(:documents, :user_id)
    add_index(:documents, :title, :unique => true)

    create_table 'images' do |t|
      t.integer :user_id, :null => :false
      t.string :title, :null => false
      t.string :resource_file_name
      t.string :resource_content_type
      t.integer :resource_file_size
      t.integer :archive_id, :integer
      t.datetime :resource_updated_at
      t.timestamps
    end
    
    add_foreign_key(:images, :user_id, :users)
    add_foreign_key :images, :archive_id, :archives
    add_index(:images, :user_id)
    add_index(:images, :title, :unique => true)
  end

  def self.down
    drop_table 'images'
    drop_table 'documents'
  end
end