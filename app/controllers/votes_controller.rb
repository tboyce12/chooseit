class VotesController < ApplicationController
  before_filter :authenticate_user!
  
  def random
    @tot = Tot.find_random_not_touched_by(current_user)
    if @tot.nil?
      redirect_to tots_index_path # TODO redirect to page saying no more tots
    end
  end

  def vote
    @tot = Tot.find_by_id_not_touched_by(params[:id], current_user)
    # TODO create a vote for current_user and the specified tot and selection
    redirect_to votes_random_path
  end
end
