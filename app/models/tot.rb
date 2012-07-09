class Tot < ActiveRecord::Base
  attr_accessible :a, :a_image, :b, :b_image
  belongs_to :user
  has_many :votes, :dependent => :destroy
  
  validates_presence_of :a, :b
  validates_length_of :a, :maximum => 30
  validates_length_of :b, :maximum => 30
  
  scope :not_created_by, lambda { |user| {:conditions => ["user_id <> ?", user.id]} }
  
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
    tot = Tot.find_by_id(id)
    return tot unless tot.user_id == user.id
  end
  
  # Find a random record that doesn't belong to user and hasn't been voted on by user
  def self.find_random_not_touched_by(user)
    tots = Tot.not_created_by(user)
    tot = tots[rand(tots.length)] unless tots.blank?
    
    # ids = connection.whereselect_all("SELECT id FROM tots WHERE )
    # find(ids[rand(ids.length)]["id"].to_i) unless ids.blank?
  end
end
