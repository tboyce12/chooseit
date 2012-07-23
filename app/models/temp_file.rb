class TempFile < ActiveRecord::Base
  attr_accessible :file
  has_attached_file :file,
    :styles         => { :medium => "300x300>", :thumb => "64x64#" },
    :storage        => :s3,
    :s3_credentials => "#{::Rails.root}/config/s3.yml",
    :dependent      => :destroy
    
  def destroy_delayed
    self.destroy
  end
  handle_asynchronously :destroy_delayed, :run_at => Proc.new { 5.minutes.from_now }
  
end
