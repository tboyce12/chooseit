class AddAttachmentFileToTempFiles < ActiveRecord::Migration
  def self.up
    change_table :temp_files do |t|
      t.has_attached_file :file
    end
  end

  def self.down
    drop_attached_file :temp_files, :file
  end
end
