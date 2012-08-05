class Users::RegistrationsController < Devise::RegistrationsController
  # From http://stackoverflow.com/questions/5113248/devise-update-user-without-password
  def update
    # Check if user has created a password before
    if current_user.haslocalpw
      # User has set a password
      # self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      #       prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
      # 
      #       if resource.update_with_password(resource_params)
      #         if is_navigational_format?
      #           flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
      #           :update_needs_confirmation : :updated
      #           set_flash_message :notice, flash_key
      #         end
      #         sign_in resource_name, resource, :bypass => true
      #         respond_with resource, :location => after_update_path_for(resource)
      #       else
      #         clean_up_passwords resource
      #         respond_with resource
      #       end
      
      super
    else
      # User has a random password
      # Override standard controller to not require a current_password for updates
      # If user is setting a new password, the standard controller (super) should process future requests
      
      # Standard Devise code
      self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
      prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

      # Custom logic
      # Check if user wants to set a password
      if params[resource_name][:password].blank?
        # User does not want to set a password
        # Remove password params to prevent a validation error
        params[resource_name].delete(:password)
        params[resource_name].delete(:password_confirmation) if params[resource_name][:password_confirmation].blank?
      else
        # User wants to set a password
        # Set haslocalpw to true so that current_password will be necessary in the future
        params[resource_name][:haslocalpw] = true
      end

      # Devise standard logic (with a couple changes to prevent errors)
      if resource.update_attributes(params[resource_name])
        if is_navigational_format?
          if resource.respond_to?(:pending_reconfirmation?) && resource.pending_reconfirmation?
            flash_key = :update_needs_confirmation
          end
          set_flash_message :notice, flash_key || :updated
        end
        sign_in resource_name, resource, :bypass => true
        respond_with resource, :location => after_update_path_for(resource)
      else
        clean_up_passwords resource
        respond_with resource
      end
    end
  end
end