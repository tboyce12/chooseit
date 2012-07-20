class VotesController < ApplicationController
  before_filter :authenticate_user!
  
  def random
    @tot = Tot.find_random_not_touched_by(current_user)
    if @tot.nil?
      redirect_to welcome_invite_path unless Chooseit::Application.config.app_debug
      @tot = Tot.find_random # If debugging, make sure we find a tot
    end
  end

  def vote
    @tot = Tot.find_by_id_not_touched_by(params[:id], current_user)
    @vote = Vote.new_from_hash({:user => current_user, :tot => @tot, :choice => params[:choice]}) unless @tot.nil?
    
    if @vote && @vote.save
      flash[:notice] = "Successfully voted!"
    else
      flash[:alert] = "Error voting."
    end
    redirect_to votes_random_path
  end
end
