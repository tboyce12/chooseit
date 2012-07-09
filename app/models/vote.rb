class Vote < ActiveRecord::Base
  attr_accessible :choice
  belongs_to :user
  belongs_to :tot
  
  validates_presence_of :choice
  validates_inclusion_of :choice, :in => %w(a b)
  
  def self.new_from_hash(hash)
    vote = self.new
    vote.tot_id = hash[:tot].id
    vote.user_id = hash[:user].id
    vote.choice = hash[:choice]
    return vote
  end
  
end
