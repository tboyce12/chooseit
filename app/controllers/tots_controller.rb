class TotsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @tots = current_user.tots
  end

  def show
    @tot = current_user.tots.find(params[:id])
  end

  def destroy
    @tot = current_user.tots.find(params[:id])
    @tot.destroy
    
    redirect_to tots_index_path
  end

  def new
    @tot = current_user.tots.new
  end

  def create
    @tot = current_user.tots.new(params[:tot])
    if @tot.save
      redirect_to tots_index_path
    else
      render :action => :new
    end
  end
end
