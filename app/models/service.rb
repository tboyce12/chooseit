class Service < ActiveRecord::Base
  belongs_to :user
  attr_accessible :provider, :uemail, :uid, :uname, :user_id
  
  validates_uniqueness_of :uid, :scope => :provider
  validates_presence_of :provider, :uid, :user_id
end
