class Tot < ActiveRecord::Base
  attr_accessible :a, :b
  belongs_to :user
  has_many :votes, :dependent => :destroy
  
  validates_presence_of :a, :b
  validates_length_of :a, :maximum => 30
  validates_length_of :b, :maximum => 30
  
  # Image attachments via paperclip + s3
  attr_accessible :a_image, :b_image
  has_attached_file :a_image,
    :styles         => { :medium => "300x300>", :thumb => "64x64#" },
    :storage        => :s3,
    :s3_credentials => "#{::Rails.root}/config/s3.yml",
    :dependent      => :destroy
  has_attached_file :b_image,
    :styles         => { :medium => "300x300>", :thumb => "64x64#" },
    :storage        => :s3,
    :s3_credentials => "#{::Rails.root}/config/s3.yml",
    :dependent      => :destroy
  validates_attachment :a_image, :size => {:less_than => 5.megabytes}
  validates_attachment :b_image, :size => {:less_than => 5.megabytes}
  before_post_process :check_file_size
  def check_file_size
    valid?
    errors[:image_file_size].blank?
  end
  
  # Methods for counting votes
  def a_votes
    votes.where("votes.choice = 'a'").length
  end
  def b_votes
    votes.where("votes.choice = 'b'").length
  end
  
  # Find the specified record, ensuring that it doesn't belong to user
  # and user hasn't voted on it
  def self.find_by_id_not_touched_by(id, user)
    not_touched_by(user).each do |tot|
      return tot if tot.id == id.to_i
    end
    nil
  end
  
  # Find a random record that doesn't belong to user and hasn't been voted on by user
  def self.find_random_not_touched_by(user)
    tots = not_touched_by(user)
    tots[rand(tots.length)] unless tots.blank?
  end
  
  # Find records that user doesn't own and hasn't voted on
  def self.not_touched_by(user)
    # Find records not owned by user
    tots = Tot.joins('INNER JOIN users ON users.id <> tots.user_id').where('users.id = ?', user.id).order('tots.id ASC')
    # For each record, add to array if user has NOT voted on it
    result = Array.new
    tots.each do |tot|
      vote = Vote.where('user_id = ? AND tot_id = ?', user.id, tot.id).first
      result.push tot unless vote
    end
    result
  end
  
  # Find any random tot with no constraints
  def self.find_random
    self.offset(rand(self.count)).first
  end
  
end
