class VisitorMailer < ActionMailer::Base
  default from: "info@chooseitgame.com"
  
  def message_email(visitor_message)
    destination = 'tboyce12@gmail.com'
    @visitor_message = visitor_message
    
    mail(:to => destination, :subject => "ChooseIt! visitor message: #{@visitor_message.name}")
  end
  
end
