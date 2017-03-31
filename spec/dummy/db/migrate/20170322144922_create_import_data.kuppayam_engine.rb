# This migration comes from kuppayam_engine (originally 20131108102730)
class CreateImportData < ActiveRecord::Migration
  def change
    create_table :import_data do |t|
    	t.integer :importable_id
      t.string  :importable_type
      t.string  :data_type
      t.string :status, :null => false, :default=>"pending", :limit=>16
      t.timestamps
    end
    add_index(:import_data, [ :importable_id, :importable_type ])
    add_index(:import_data, :data_type )
    add_index(:import_data, :status )
  end
end