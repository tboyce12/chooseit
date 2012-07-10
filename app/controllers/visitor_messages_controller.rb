class VisitorMessagesController < ApplicationController
  def new
    @visitor_message = VisitorMessage.new
  end

  def create
    @visitor_message = VisitorMessage.new(params[:visitor_message])
    if @visitor_message.valid?
      VisitorMailer.message_email(@visitor_message).deliver
      redirect_to visitor_messages_thanks_path, notice: "Message sent! Thank you for contacting us."
    else
      render "new"
    end
  end
  
  def thanks
  end
end
