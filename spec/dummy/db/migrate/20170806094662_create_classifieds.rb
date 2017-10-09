class CreateClassifieds < ActiveRecord::Migration[5.0]
  def change
    create_table :classifieds do |t|
      
      t.string :title, :null => false
      t.text   :description
      
      t.boolean :featured, default: false
      t.string :status, :null => false, :default=>"pending", :limit=>16

      t.timestamps null: false
    end
    add_index :classifieds, :status
  end
end
