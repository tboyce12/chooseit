class AddAttachmentAImageBImageToTots < ActiveRecord::Migration
  def self.up
    change_table :tots do |t|
      t.has_attached_file :a_image
      t.has_attached_file :b_image
    end
  end

  def self.down
    drop_attached_file :tots, :a_image
    drop_attached_file :tots, :b_image
  end
end
