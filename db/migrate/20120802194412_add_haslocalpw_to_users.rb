class AddHaslocalpwToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :haslocalpw, :null => false, :default => true
    end
  end
end
