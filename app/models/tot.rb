class Tot < ActiveRecord::Base
  attr_accessible :a, :b
  belongs_to :user
  has_many :votes, :dependent => :destroy
  
  validates_presence_of :a, :b
  validates_length_of :a, :maximum => 30
  validates_length_of :b, :maximum => 30
  
  # Image attachments via paperclip + s3
  attr_accessible :a_image, :b_image
  has_attached_file :a_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  has_attached_file :b_image, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  
  # scope :not_created_by, lambda { |user| {:conditions => ["user_id <> ?", user.id]} }
  
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
  end
  
  # Find a random record that doesn't belong to user and hasn't been voted on by user
  def self.find_random_not_touched_by(user)
    tots = not_touched_by(user)
    tots[rand(tots.length)] unless tots.blank?
    
    # ids = connection.whereselect_all("SELECT id FROM tots WHERE )
    # find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
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
  
end
