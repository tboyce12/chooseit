class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  before_filter :retrieve_auth
  after_filter :remember_user
  
  def facebook
    hash = {
      :provider => 'facebook',
      :uid => @auth.uid,
      :uname => @auth.info.name,
      :uemail => @auth.info.email
    }
    kind = 'Facebook'
    authorize hash, kind
  end
  
  def twitter
    hash = {
      :provider => 'twitter',
      :uid => @auth.uid,
      :uname => @auth.info.name,
      :uemail => ''
    }
    kind = 'Twitter'
    authorize hash, kind
  end
  
  def google_oauth2
    hash = {
      :provider => 'google',
      :uid => @auth.uid,
      :uname => @auth.info.name,
      :uemail => @auth.info.email
    }
    kind = 'Google'
    authorize hash, kind
  end
  
  private
  def authorize(hash=nil, kind=nil)
    # Check if user is already signed in
    if !user_signed_in?
      # User is not yet signed in
      # Check if user has already signed in with this service
      s = Service.find_by_provider_and_uid(hash[:provider], hash[:uid])
      if s
        # Service found, sign in user
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
        sign_in_and_redirect s.user, :event => :authentication
      else
        # Service not found, try to find user by email or register a new user
        # Check if an email was provided (so we can link to existing user)
        if !hash[:uemail].blank?
          # Email provided, search for user with this email
          u = User.find_by_email(hash[:uemail])
          # Check if user with matching email was found
          if u
            # User found
            # Create service for user
            u.services.create(hash)
            # Sign in user
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
            sign_in_and_redirect u, :event => :authentication
          else
            # User not found
            # Create new user
            u = User.new :email => hash[:uemail], :password => Devise.friendly_token[0,20], :haslocalpw => false
            # Create service for user
            u.services.build(hash)
            # Save new record
            u.save!
            # Sign in user
            flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => kind
            sign_in_and_redirect u, :event => :authentication
          end
        else
          # Email not provided
          # Save data for user and service in session
          session["devise.auth_data"] = hash
          # Redirect to registration page asking for email
          flash[:notice] = "Almost ready! We just need your email address to finish the registration process."
          redirect_to new_user_registration_url
        end
      end
    else
      # User is currently signed in
      # Check if this service is already linked to user
      s = Service.find_by_provider_and_uid(hash[:provider], hash[:uid])
      if s
        # Service linked to user
        # Do nothing
        # Redirect to account page
        flash[:notice] = "#{kind} is already added"
        redirect_to edit_user_registration_path
      else
        # Service is not linked to user
        # Create service for user
        current_user.services.create(hash)
        # Redirect to account page
        flash[:notice] = "Added #{kind} as a login method"
        redirect_to edit_user_registration_path
      end
    end
  end
  
  protected
  def retrieve_auth
    @auth = request.env["omniauth.auth"]
  end
  
  def remember_user
    remember_me(current_user) if current_user
  end
  
end
