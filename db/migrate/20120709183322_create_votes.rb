class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :user_id, :null => false
      t.integer :tot_id, :null => false
      t.string :choice, :null => false, :limit => 1

      t.timestamps
    end
  end
end
