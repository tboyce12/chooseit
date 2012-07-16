class RemoveImagesFromTots < ActiveRecord::Migration
  def up
    remove_column :tots, :a_image
        remove_column :tots, :b_image
      end

  def down
    add_column :tots, :b_image, :string
    add_column :tots, :a_image, :string
  end
end
