class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #          :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me#, :provider, :uid
  attr_accessible :haslocalpw
  # attr_accessible :title, :body
  
  # Associations
  has_many :tots, :dependent => :destroy
  has_many :votes, :dependent => :destroy
  has_many :services, :dependent => :destroy
  
  
  # # Find or create user when Facebook OAuth succeeds
  #   def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
  #     user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #     unless user
  #       # name:auth.extra.raw_info.name,
  #       user = User.create(provider:auth.provider,
  #                          uid:auth.uid,
  #                          email:auth.info.email,
  #                          password:Devise.friendly_token[0,20]
  #                          )
  #     end
  #     user
  #   end
  #   
  #   # Find or create user when Twitter OAuth succeeds
  #   def self.find_for_twitter_oauth(auth, signed_in_resource=nil)
  #     user = User.where(:provider => auth.provider, :uid => auth.uid).first
  #     unless user
  #       user = User.create(provider:auth.provider,
  #                          uid:auth.uid,
  #                          email:auth.info.nickname,
  #                          password:Devise.friendly_token[0,20]
  #                          )
  #     end
  #     user
  #   end
  
  # Copy session data to model
  def self.new_with_session(params, session)
    super.tap do |user|
      if hash = session["devise.auth_data"]
        user.services.build(hash)
        user.haslocalpw = false
      end
        
        # if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        #           # Facebook
        #           user.email = data["email"] if user.email.blank?
        #         elsif data = session["devise.twitter_data"]
        #           # Twitter
        #           # TODO Request email, or start using name instead
        #           email = data["info"]["nickname"]
        #           user.email = email if user.email.blank?
        #         end
    end
  end
  
  protected
  def password_required?
    haslocalpw
  end
  
end
