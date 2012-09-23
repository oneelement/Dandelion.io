class GoogleContact
  include Mongoid::Document
  #include Mongoid::Timestamps
  
  belongs_to :user
   
  field :name
  field :google_id
  field :contact_id
end
