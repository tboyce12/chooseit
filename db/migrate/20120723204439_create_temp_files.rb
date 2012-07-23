class CreateTempFiles < ActiveRecord::Migration
  def change
    create_table :temp_files do |t|

      t.timestamps
    end
  end
end
