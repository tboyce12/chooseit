class TempFilesController < ApplicationController
  def create
    @temp_file = TempFile.create(:file => params[:file_0])
    @temp_file.save!
    @temp_file.destroy_delayed
    render text:@temp_file.file.url(:medium)
  end
end
