# Guests can send VisitorEmails by filling out the contact us form
class VisitorMessage
  include ActiveAttr::Model
  
  attribute :name
  attribute :content
  attribute :email
  
  validates_presence_of :content
  #validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  #validates_length_of :content, :maximum => 500
  
end