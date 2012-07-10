class WelcomeController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @user = current_user
  end
  
  def invite
  end
end
