class Message
  include ActiveAttr::Model
  
  attribute :name
  attribute :email
  attribute :message
  
  validates_presence_of :name, :message
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  validates_length_of :message, :maximum => 500
end