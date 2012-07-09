class Tot < ActiveRecord::Base
  attr_accessible :a, :a_image, :b, :b_image
  belongs_to :user
end
