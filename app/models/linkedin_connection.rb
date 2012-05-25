class LinkedinConnection
  include Mongoid::Document
  
  belongs_to :user
  
  field :name
  field :linkedin_id
  field :contact_id
end
