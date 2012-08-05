class CreateServices < ActiveRecord::Migration
  
  # User faux model
  class User < ActiveRecord::Base
    has_many :services
    attr_accessible :provider, :uid
  end
  # Service faux model
  class Service < ActiveRecord::Base
    belongs_to :user
    attr_accessible :provider, :uid, :uname, :uemail
  end
  
  def up
    # Create services table
    create_table :services do |t|
      t.integer :user_id, :null => false
      t.string :provider
      t.string :uid
      t.string :uname
      t.string :uemail

      t.timestamps
    end
    
    # For users with a provider and uid, build a service containing that info
    User.reset_column_information
    User.all.each do |user|
      if !user.provider.blank? && !user.uid.blank?
        # Get attrs for this service
        provider = user.provider
        uid = user.uid
        uname = nil
        uemail = nil
        if isEmail?(user.email)
          uemail = user.email
        else
          uname = user.email
        end
        
        # Build the service for this user
        user.services.create({:provider => provider, :uid => uid, :uname => uname, :uemail => uemail})
      end
    end
    
    # Remove provider and uid columns from user
    remove_column :users, :provider
    remove_column :users, :uid
  end
  
  def down
    # Add provider and uid columns to user
    add_column :users, :provider, :string
    add_column :users, :uid, :string
    
    # For each service, copy its info to its owning user
    Service.all.each do |s|
      s.user.provider = s.provider
      s.user.uid = s.uid
      s.user.save!
    end
    
    # Drop services table
    drop_table :services
  end
  
  private
  def isEmail?(str)
    return str.match(/@/) ? true : false
  end
  
end
