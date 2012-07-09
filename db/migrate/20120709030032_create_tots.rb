class CreateTots < ActiveRecord::Migration
  def change
    create_table :tots do |t|
      t.integer :user_id, :null => false
      
      t.string :a, :null => false
      t.string :b, :null => false
      t.string :a_image
      t.string :b_image

      t.timestamps
    end
  end
end
