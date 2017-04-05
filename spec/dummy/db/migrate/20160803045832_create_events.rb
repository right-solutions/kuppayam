class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      
      t.string :title, :null => false
      t.string :venue, :null => false

      t.text   :description
      
      t.date     :date, :null => true
      t.datetime :starts_at, :null => true
      t.datetime :ends_at, :null => true
      
      t.boolean :featured, default: false
      t.string :status, :null => false, :default=>"unpublished", :limit=>16

      t.timestamps null: false
    end
    add_index :events, :status
  end
end
