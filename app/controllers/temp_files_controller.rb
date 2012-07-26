class TempFilesController < ApplicationController
  def create
    choice = request.headers['chooseit_choice']
    @temp_file = TempFile.create(:file => params[:file_0])
    @temp_file.save!
    @temp_file.destroy_delayed
    my_response = {choice:choice, url:@temp_file.file.url(:medium)}
    render text:my_response.to_json
  end
end
