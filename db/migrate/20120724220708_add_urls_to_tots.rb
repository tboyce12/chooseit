class AddUrlsToTots < ActiveRecord::Migration
  def change
    add_column :tots, :a_url, :string
    add_column :tots, :b_url, :string
  end
end
