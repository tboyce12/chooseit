class ServicesController < ApplicationController
  def destroy
    # Remove an authentication service linked to the current user
    @service = current_user.services.find(params[:id])
    if current_user.services.count == 1 && current_user.haslocalpw == false
      flash[:alert] = "Cannot remove only login method. First you must create a password to access your account."
    else
      @service.destroy
    end
    redirect_to edit_user_registration_path
  end
end
