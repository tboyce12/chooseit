class TempFilesController < ApplicationController
  def create
    @temp_file = TempFile.create(:file => params[:file_0])
    @temp_file.save!
    render text:@temp_file.file.url(:medium)
  end

  def destroy
  end
end
